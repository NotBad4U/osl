use crate::transpiler::errors::Result;
use lang_c::span::Span;

use super::*;
use crate::node;

impl Transpiler {
    pub(super) fn transpile_expression(&mut self, exp: &Expression) -> Result<EffectsExp> {
        match exp {
            Expression::Identifier(box node!(Identifier { name })) => {
                Ok(EffectsExp::new(None, Exp::Id(name.to_string())))
            }
            // transpile free(x)
            Expression::Call(
                box node!(CallExpression {
                    callee: box node!(Expression::Identifier(box node!(Identifier { name }))),
                    arguments,
                }),
            ) if utils::is_deallocate_memory_function(name) => {
                Ok(EffectsExp::from(self.transpile_deallocate(arguments)?))
            }
            Expression::Call(box node!(call)) => self.transpile_call_expression(&call),
            Expression::BinaryOperator(box node!(bin_op)) => self.transpile_binary_operator(bin_op),
            Expression::Constant(constant) => Ok(EffectsExp::new(
                None,
                self.transpile_constant(&constant.node),
            )),
            Expression::Cast(box node!(cast)) => self.transpile_cast_expression(&cast),
            Expression::StringLiteral(_) => {
                Ok(EffectsExp::new(None, Exp::NewResource(Props::new())))
            }
            Expression::UnaryOperator(box node!(unary)) => self.transpile_unary_expression(&unary),
            Expression::Member(box node!(m)) => {
                Ok(EffectsExp::from(self.transpile_struct_member(m)?))
            }
            expression => Err(TranspilationError::Unimplemented(get_span_from_expression(
                expression,
            ))),
        }
    }

    fn transpile_cast_expression(&mut self, cast: &CastExpression) -> Result<EffectsExp> {
        self.transpile_expression(&cast.expression.node)
    }

    fn transpile_constant(&self, constant: &Constant) -> Exp {
        match constant {
            Constant::Float(_) | Constant::Integer(_) => {
                Exp::NewResource(Props(vec![Prop::Copy, Prop::Mut]))
            }
            Constant::Character(_) => Exp::NewResource(Props::new()),
        }
    }

    ///// Transpile call method to free(x) into deallocate (OSL)
    pub(super) fn transpile_deallocate(
        &mut self,
        arguments: &Vec<Node<Expression>>,
    ) -> Result<Exp> {
        // Free should have only one parameter: void free(void *ptr);
        match arguments.first() {
            Some(node!(Expression::Identifier(box node!(Identifier { ref name })))) => Ok(
                Exp::Statement(box Stmt::Deallocate(Exp::Id(name.to_string()))),
            ),
            Some(ref e) => Err(TranspilationError::NotTranspilable(
                get_span_from_expression(&e.node),
                "free expression to complicate".into(),
            )),
            None => Err(TranspilationError::Message("".into())),
        }
    }

    ///// Transpile the call of function.
    pub(super) fn transpile_call_expression(
        &mut self,
        call_exp: &CallExpression,
    ) -> Result<EffectsExp> {
        let function_name = extract!(Expression::Identifier(_), &call_exp.callee.node)
            .ok_or(TranspilationError::MessageSpan(
                get_span_from_expression(&(*call_exp).callee.node),
                "Cannot find function name in {}".into(),
            ))?
            .node
            .name
            .to_string();

        // Pass the required parameters along with the function name
        // We don't distinguish Call by value or by reference with OSL.
        let (effects, arguments) = call_exp.arguments.iter().map(|node| &node.node).try_fold(
            (Vec::new(), Vec::new()),
            |mut acc, expression| {
                self.transpile_expression(expression)
                    .and_then(|mut effexp| {
                        acc.0.append(&mut effexp.effects);
                        acc.1.push(effexp.expression);
                        Ok(acc)
                    })
            },
        )?;

        // the call to std function need to be a little modify because they use
        // variadic arguments. So we have to call the corresponding unrolled version.
        // See stdfun.rs for more information.
        let function_name = if self.stdfun.is_std_function(&function_name) {
            // take the arity of arguments and add it in postfix of the name
            format!("{}{}", function_name, arguments.len().to_string())
        } else {
            function_name
        };

        Ok(EffectsExp::new(
            Some(effects),
            Exp::Call(function_name, Exps(arguments)),
        ))
    }

    pub(super) fn transpile_binary_operator(
        &mut self,
        bop: &BinaryOperatorExpression,
    ) -> Result<EffectsExp> {
        let left = &bop.lhs.node;
        let right = &bop.rhs.node;
        let operator = &bop.operator.node;

        match (left, operator, right) {
            // Basic assignment a = b;
            //(left, BinaryOperator::Assign, right) => self.transpile_assign_expression(left, right),
            (
                left,
                BinaryOperator::Greater
                | BinaryOperator::GreaterOrEqual
                | BinaryOperator::Less
                | BinaryOperator::LessOrEqual
                | BinaryOperator::LogicalAnd
                | BinaryOperator::LogicalOr
                | BinaryOperator::Modulo
                | BinaryOperator::Equals
                | BinaryOperator::NotEquals
                | BinaryOperator::Multiply
                | BinaryOperator::Divide
                | BinaryOperator::Plus
                | BinaryOperator::Minus
                | BinaryOperator::ShiftLeft
                | BinaryOperator::ShiftRight
                | BinaryOperator::BitwiseAnd
                | BinaryOperator::BitwiseXor
                | BinaryOperator::BitwiseOr,
                right,
            ) => self.transpile_boolean_condition_expression(left, right),
            (
                Expression::Identifier(_),
                BinaryOperator::AssignMultiply
                | BinaryOperator::AssignDivide
                | BinaryOperator::AssignModulo
                | BinaryOperator::AssignPlus
                | BinaryOperator::AssignMinus
                | BinaryOperator::AssignShiftLeft
                | BinaryOperator::AssignShiftRight
                | BinaryOperator::AssignBitwiseAnd
                | BinaryOperator::AssignBitwiseXor
                | BinaryOperator::AssignBitwiseOr,
                right,
            ) => self.transpile_mutable_assign_expression(right),
            // a[..][..][..][..]...
            (left, BinaryOperator::Index, _) => Ok(EffectsExp::new(
                None,
                Exp::Read(box Exp::Id(get_matrices_tag(&left))),
            )),
            (left, op, right) => Err(TranspilationError::Unsupported(
                get_span_from_expression(left),
                format!("{:#?} \n {:?} \n {:#?}", left, op, right),
            )),
        }
    }

    pub(super) fn transpile_unary_expression(
        &mut self,
        unary: &UnaryOperatorExpression,
    ) -> Result<EffectsExp> {
        match (&unary.operand.node, &unary.operator.node) {
            // ++T, --T, T++, T--
            (
                Expression::Identifier(box node!(Identifier { name })),
                UnaryOperator::PostDecrement
                | UnaryOperator::PostIncrement
                | UnaryOperator::PreDecrement
                | UnaryOperator::PreIncrement,
            ) => self
                .context
                .get_props_of_variable(name)
                .map(|props| {
                    EffectsExp::new(
                        None,
                        Exp::Write(box Exp::NewResource(props), box Exp::Id(name.to_string())),
                    )
                })
                .ok_or(TranspilationError::Message(format!(
                    "the variable {} is not defined",
                    name
                ))),
            // *T
            (
                Expression::Identifier(box node!(Identifier { name })),
                UnaryOperator::Indirection,
            ) => Ok(EffectsExp::new(
                None,
                Exp::Deref(box Exp::Id(name.to_string())),
            )),
            // &T
            (e, UnaryOperator::Address) => self.transpile_expression(e),
            (operand, _) => Err(TranspilationError::Unimplemented(get_span_from_expression(
                operand,
            ))),
        }
    }

    #[inline]
    pub(super) fn transpile_mutable_assign_expression(
        &mut self,
        right: &Expression,
    ) -> Result<EffectsExp> {
        self.transpile_expression(right)
    }

    /// Combine the effects on the left and right
    /// and return a Unit expression with his Effects
    pub(super) fn transpile_boolean_condition_expression(
        &mut self,
        left: &Expression,
        right: &Expression,
    ) -> Result<EffectsExp> {
        self.get_effects_of_expression(left)
            .and_then(|mut left_effects| {
                self.get_effects_of_expression(right).map(|right_effects| {
                    left_effects.extend(right_effects);
                    EffectsExp::new(Some(left_effects), Exp::Unit)
                })
            })
    }

    // Transpile assign binary expression.
    // Some of the pattern matching cases here are
    // done to optimize the transpiliation.

    pub(super) fn transpile_assign_expression(
        &mut self,
        left: &Expression,
        right: &Expression,
    ) -> Result<EffectsExp> {
        match (left, right) {
            // Change Value of Array elements
            (
                Expression::BinaryOperator(
                    box node!(BinaryOperatorExpression {
                        operator: node!(BinaryOperator::Index),
                        lhs: box node!(Expression::Identifier(box node!(Identifier { name }))),
                        ..
                    }),
                ),
                right,
            ) => Ok(EffectsExp::new(
                Some(self.get_effects_of_expression(right)?),
                Exp::Write(
                    box Exp::NewResource(self.context.get_props_of_variable(name).unwrap()),
                    box Exp::Id(name.to_string()),
                ),
            )),
            //Expression::Identifier(box Node{ node: Identifier{name}, .. } ), , _) => Stmts::from(Stmt::Expression(Exp::Id(name.to_string()))),
            // parse dynamic memory allocation assignment:  ptr = (cast-type*) malloc(byte-size)
            // Malloc, Calloc, etc. returns a pointer of type void which can be cast into a pointer of any form.
            // Most usage of malloc follow this pattern.
            (
                Expression::Identifier(box node!(Identifier { name: left_id })),
                // Initial memory allocation : x = (T*) malloc(y);
                Expression::Cast(
                    box node!(CastExpression {
                        expression: box node!(Expression::Call(box node!(CallExpression {
                            callee: box node!(Expression::Identifier(box node!(Identifier {
                                name
                            }))),
                            ..
                        }))),
                        type_name: node!(TypeName { declarator, .. }),
                    }),
                ),
            ) if utils::is_allocate_memory_function(name) => Ok(EffectsExp::new(
                None,
                Exp::Write(
                    box Exp::NewResource(utils::get_props_from_declarator(&declarator)),
                    box Exp::Id(left_id.to_string()),
                ),
            )),
            // Basic assignment a = b;
            (
                Expression::Identifier(box node!(Identifier { name: l_id })),
                Expression::Identifier(box node!(Identifier { name: r_id })),
            ) => Ok(if self.context.is_constant_in_enum(r_id) {
                EffectsExp::new(
                    None,
                    Exp::Write(
                        box Exp::NewResource(Props::from(Prop::Copy)),
                        box Exp::Id(l_id.to_string()),
                    ),
                )
            } else {
                EffectsExp::new(
                    None,
                    Exp::Write(box Exp::Id(r_id.into()), box Exp::Id(l_id.to_string())),
                )
            }),
            // Address assignment a = &b;
            // We should consider this as a borrow
            (
                Expression::Identifier(box node!(left_id)),
                Expression::UnaryOperator(
                    box node!(UnaryOperatorExpression {
                        operator: node!(UnaryOperator::Address),
                        operand: box node!(Expression::Identifier(box node!(right_id))),
                    }),
                ),
            ) => Ok(EffectsExp::new(
                None,
                Exp::Statement(box self.transpile_ref_assignment(left_id, right_id)),
            )),
            // a = <Constant>;
            (Expression::Identifier(box node!(Identifier { name })), Expression::Constant(_)) => {
                Ok(EffectsExp::new(
                    None,
                    Exp::Write(
                        box Exp::NewResource(self.context.get_props_of_variable(name).ok_or(
                            TranspilationError::MessageSpan(
                                get_span_from_expression(left),
                                format!("can't get props from {}", name),
                            ),
                        )?),
                        box Exp::Id(name.to_string()),
                    ),
                ))
            }
            (
                Expression::Identifier(box node!(Identifier { name: left })),
                Expression::Identifier(box node!(Identifier { name: right })),
            ) => Ok(EffectsExp::new(
                None,
                Exp::Write(box Exp::Id(right.into()), box Exp::Id(left.into())),
            )),
            // Default: a = <expression>
            (
                Expression::Identifier(box Node {
                    node: Identifier { name },
                    span,
                }),
                right,
            ) => {
                // Get all the expression to check before transfering a new resource to the left Identifier.
                // For exemple: A = A + 1;
                // Here we have to read first A, and after Transfer a NewResource to A.
                let effects = self.get_effects_of_expression(right)?;

                let props = self.context.get_props_of_variable(name).ok_or(
                    TranspilationError::MessageSpan(
                        *span,
                        "can't find his Props in context".into(),
                    ),
                )?;
                Ok(EffectsExp::new(
                    Some(effects),
                    Exp::Write(box Exp::NewResource(props), box Exp::Id(name.into())),
                ))
            }
            // *a = b;
            (Expression::UnaryOperator(unary), right) => self
                .transpile_deref(&unary.node, right)
                .map(|expression| EffectsExp::new(None, expression)),
            // a[][].. = ....
            (
                Expression::BinaryOperator(
                    box node!(BinaryOperatorExpression {
                        operator: node!(BinaryOperator::Index),
                        lhs: box node!(lhs),
                        rhs: box node!(rhs)
                    }),
                ),
                right,
            ) => {
                let mut effects_right = self.get_effects_of_expression(right)?;
                let mut effects_rhs = self.get_effects_of_expression(rhs)?;
                effects_rhs.append(&mut effects_right);

                Ok(EffectsExp::new(
                    Some(effects_rhs),
                    Exp::Write(
                        box Exp::NewResource(Props::new()),
                        box Exp::Id(get_matrices_tag(&lhs)),
                    ),
                ))
            }
            (left, _) => Err(TranspilationError::Unimplemented(get_span_from_expression(
                left,
            ))),
        }
    }

    /// Get effect of an expression
    /// For example, take this boolean expressions:
    /// - a + b we have the effects: read(a), read(b)
    /// - a < foo(b) we have the effects: read(a), call foo(b)
    pub(super) fn get_effects_of_expression(&self, expression: &Expression) -> Result<Vec<Effect>> {
        match expression {
            Expression::Identifier(box node!(Identifier { name })) => {
                Ok(vec![Effect::Read(Exp::Id(name.clone()))])
            }
            Expression::Constant(box node!(_)) => {
                Ok(vec![Effect::Constant(Exp::NewResource(Props::new()))])
            }
            Expression::StringLiteral(_) => {
                Ok(vec![Effect::Constant(Exp::NewResource(Props::new()))])
            }
            Expression::Member(box node!(MemberExpression { identifier, .. })) => {
                Ok(vec![Effect::Read(Exp::Id(identifier.node.name.clone()))])
            }
            Expression::Call(
                box node!(CallExpression {
                    callee: box node!(Expression::Identifier(box node!(Identifier { name }))),
                    arguments,
                }),
            ) => arguments
                .iter()
                .map(|node!(argument)| self.get_effects_of_expression(argument))
                .collect::<Result<Vec<_>, _>>()
                .map(|vecs| vecs.into_iter().flatten().collect())
                .map(|args: Vec<_>| vec![Effect::Call(Exp::Call(name.to_string(), Exps(vec![])))]), //FIXME
            Expression::UnaryOperator(box node!(UnaryOperatorExpression{box operand, ..})) => {
                self.get_effects_of_expression(&operand.node)
            }
            Expression::BinaryOperator(box node!(BinaryOperatorExpression { lhs, rhs, .. })) => {
                let mut effects = self.get_effects_of_expression(&lhs.node)?;
                let effects_right = self.get_effects_of_expression(&rhs.node)?;
                effects.extend(effects_right);
                Ok(effects)
            }
            Expression::Conditional(
                box node!(ConditionalExpression {
                    condition,
                    then_expression,
                    else_expression
                }),
            ) => {
                let mut effects = self.get_effects_of_expression(&condition.node)?;
                let then_expression = self.get_effects_of_expression(&then_expression.node)?;
                let else_expression = self.get_effects_of_expression(&else_expression.node)?;
                effects.extend(then_expression);
                effects.extend(else_expression);
                Ok(effects)
            }
            Expression::Cast(_)
            | Expression::OffsetOf(_)
            | Expression::SizeOf(_)
            | Expression::AlignOf(_)
            | Expression::VaArg(_) => Ok(vec![]),
            Expression::GenericSelection(box node) => Err(TranspilationError::Unsupported(
                node.span,
                "Getting effects from GenericSelection is not supported".into(),
            )),
            Expression::Statement(box node) => Err(TranspilationError::Unsupported(
                node.span,
                "Getting effects from statement in declaration is not supported yet".into(),
            )),
            expression => Err(TranspilationError::NotTranspilable(
                get_span_from_expression(expression),
                "Getting effects from statement in declaration is not supported yet".into(),
            )),
        }
    }

    pub(super) fn transpile_deref(
        &mut self,
        unary: &UnaryOperatorExpression,
        right: &Expression,
    ) -> Result<Exp> {
        match (&unary.operator.node, &unary.operand.node, right) {
            (UnaryOperator::Indirection, Expression::Identifier(box node!(node)), right) => {
                Ok(Exp::Deref(box Exp::Id(node.name.clone())))
            }
            (_operator, operand, _expression) => Err(TranspilationError::NotTranspilable(
                get_span_from_expression(operand),
                "Cannot transpile to deref statement".into(),
            )),
        }
    }

    pub(super) fn transpile_struct_member(&mut self, member: &MemberExpression) -> Result<Exp> {
        get_structure_tag(member).map(|id| Exp::Id(id))
    }
}

/// Function used by the reporter to report diagnostic
fn get_span_from_expression(e: &Expression) -> Span {
    match e {
        Expression::Identifier(box node) => node.span,
        Expression::Call(box node) => node.span,
        Expression::BinaryOperator(box node) => node.span,
        Expression::Constant(box node) => node.span,
        Expression::Cast(box node) => node.span,
        Expression::StringLiteral(node) => node.span,
        Expression::UnaryOperator(node) => node.span,
        Expression::CompoundLiteral(box node) => node.span,
        Expression::GenericSelection(box node) => node.span,
        Expression::Member(box node) => node.span,
        Expression::SizeOf(box node) => node.span,
        Expression::AlignOf(box node) => node.span,
        Expression::Conditional(box node) => node.span,
        Expression::Comma(box exps) => get_span_from_expression(&exps.first().unwrap().node),
        Expression::VaArg(box node) => node.span,
        Expression::Statement(box node) => node.span,
        Expression::OffsetOf(box node) => node.span,
    }
}

/// C-Lang library put the structure tag at the tail of the list.
/// We have to iterate recursively to extract the structure tag.
fn get_structure_tag(member: &MemberExpression) -> Result<String> {
    match &(*member.expression).node {
        Expression::Member(box node!(ref m)) => get_structure_tag(m),
        Expression::Identifier(box node!(Identifier { name })) => Ok(name.into()),
        expression => Err(TranspilationError::NotTranspilable(
            get_span_from_expression(expression),
            "structure tag which is not an Expression::Identifier".into(),
        )),
    }
}

/// C-Lang library put the matrices tag at the tail of the list.
/// We have to iterate recursively to extract the matrices tag.
fn get_matrices_tag(expression: &Expression) -> String {
    match expression {
        Expression::BinaryOperator(box node!(BinaryOperatorExpression{ box lhs, .. })) => {
            get_matrices_tag(&lhs.node)
        }
        Expression::Identifier(box node!(Identifier { name })) => name.into(),
        _ => unimplemented!("Finish the visitor"),
    }
}
