use super::*;

impl Transpiler {
    pub(super) fn transpile_expression(&mut self, exp: &Expression) -> Stmts {
        match exp {
            Expression::Identifier(box Node {
                node: Identifier { name },
                ..
            }) => Stmts::from(Stmt::Expression(Exp::Id(name.to_string()))),
            Expression::Call(box Node { node: call, .. }) => self.transpile_call_expression(&call),
            Expression::BinaryOperator(box Node { node: bin_op, .. }) => {
                self.transpile_binary_operator(bin_op)
            }
            Expression::Constant(constant) => Stmts::from(self.transpile_constant(&constant.node)),
            Expression::Cast(box Node { node: cast, .. }) => self.transpile_cast_expression(&cast),
            Expression::StringLiteral(_) => Stmts::new(),
            Expression::UnaryOperator(box Node { node: unary, .. }) => {
                self.transpile_unary_expression(&unary)
            }
            e => unimplemented!("{:?}", e),
        }
    }

    fn transpile_cast_expression(&mut self, cast: &CastExpression) -> Stmts {
        self.transpile_expression(&cast.expression.node)
    }

    fn transpile_constant(&self, constant: &Constant) -> Stmt {
        match constant {
            Constant::Float(_) | Constant::Integer(_) => {
                Stmt::Val(Exp::NewRessource(Props::from(Prop::Copy)))
            }
            Constant::Character(_) => Stmt::Val(Exp::NewRessource(Props::new())),
        }
    }

    pub(super) fn transpile_call_expression(&mut self, call_exp: &CallExpression) -> Stmts {
        let callee = extract!(Expression::Identifier(_), &call_exp.callee.node)
            .unwrap()
            .node
            .name
            .to_string();

        if self.stdfun.is_std_function(callee.as_str()) {
            self.transpile_std_function(&callee, call_exp)
        } else {
            let arguments = call_exp
                .arguments
                .iter()
                .map(|node| &node.node)
                .map(|exp| self.transpile_expression(&exp).first().unwrap().clone()) //FIXME: pb with multiple stat
                .map(|exp| extract!(Stmt::Expression(_), exp).unwrap())
                .collect::<Vec<Exp>>();
            Stmts::from(Stmt::Expression(Exp::Call(callee, Exps(arguments))))
        }
    }

    pub(super) fn transpile_binary_operator(&mut self, bop: &BinaryOperatorExpression) -> Stmts {
        let left = &bop.lhs.node;
        let right = &bop.rhs.node;
        let operator = &bop.operator.node;

        match (left, operator, right) {
            // Basic assignment a = b;
            (left, BinaryOperator::Assign, right) => self.transpile_assign_expression(left, right),
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
            e => unimplemented!("{:?}", e),
        }
    }

    pub(super) fn transpile_unary_expression(&self, unary: &UnaryOperatorExpression) -> Stmts {
        match (&unary.operand.node, &unary.operator.node) {
            (
                Expression::Identifier(box Node {
                    node: Identifier { name },
                    ..
                }),
                UnaryOperator::PostDecrement
                | UnaryOperator::PostIncrement
                | UnaryOperator::PreDecrement
                | UnaryOperator::PreIncrement,
            ) => Stmts::from(Stmt::Transfer(
                Exp::NewRessource(
                    self.context
                        .get_props_of_variable(name)
                        .expect(&format!("the variable {} is not defined", name)),
                ),
                Exp::Id(name.to_string()),
            )),
            (
                Expression::Identifier(box Node {
                    node: Identifier { name },
                    ..
                }),
                UnaryOperator::Indirection,
            ) => Stmts::from(Stmt::Expression(Exp::Deref(box Exp::Id(name.to_string())))),
            _ => Stmts::new(),
        }
    }

    #[inline]
    pub(super) fn transpile_mutable_assign_expression(&mut self, right: &Expression) -> Stmts {
        self.transpile_expression(right)
    }

    pub(super) fn transpile_boolean_condition_expression(
        &mut self,
        left: &Expression,
        right: &Expression,
    ) -> Stmts {
        let mut stmts = self.transpile_expression(left);
        stmts.0.extend(self.transpile_expression(right).0);
        stmts
    }

    pub(super) fn transpile_assign_expression(
        &mut self,
        left: &Expression,
        right: &Expression,
    ) -> Stmts {
        match (left, right) {
            // parse dynamic memory allocation assignment:  ptr = (cast-type*) malloc(byte-size)
            // Malloc, Calloc, etc. returns a pointer of type void which can be cast into a pointer of any form.
            // Most usage of malloc follow this pattern.
            (
                Expression::Identifier(box Node {
                    node: Identifier { name: left_id },
                    ..
                }),
                Expression::Cast(box Node {
                    node:
                        CastExpression {
                            expression:
                                box Node {
                                    node:
                                        Expression::Call(box Node {
                                            node:
                                                CallExpression {
                                                    callee:
                                                        box Node {
                                                            node:
                                                                Expression::Identifier(box Node {
                                                                    node: Identifier { name },
                                                                    ..
                                                                }),
                                                            ..
                                                        },
                                                    ..
                                                },
                                            ..
                                        }),
                                    ..
                                },
                            type_name:
                                Node {
                                    node: TypeName { declarator, .. },
                                    ..
                                },
                        },
                    ..
                }),
            ) if utils::is_allocate_memory_function(name) => Stmts::from(Stmt::Transfer(
                Exp::NewRessource(utils::get_props_from_declarator(&declarator)),
                Exp::Id(left_id.to_string()),
            )),
            // Basic assignment a = b;
            (
                Expression::Identifier(box Node {
                    node: Identifier { name: l_id },
                    ..
                }),
                Expression::Identifier(box Node {
                    node: Identifier { name: r_id },
                    ..
                }),
            ) => Stmts::from(Stmt::Transfer(
                Exp::Id(l_id.to_string()),
                Exp::Id(r_id.into()),
            )),
            // Address assignment a = &b;
            // We should consider this as a borrow
            (
                Expression::Identifier(box Node { node: left_id, .. }),
                Expression::UnaryOperator(box Node {
                    node:
                        UnaryOperatorExpression {
                            operator:
                                Node {
                                    node: UnaryOperator::Address,
                                    ..
                                },
                            operand:
                                box Node {
                                    node: Expression::Identifier(box Node { node: right_id, .. }),
                                    ..
                                },
                        },
                    ..
                }),
            ) => Stmts::from(self.transpile_ref_assignment(left_id, right_id)),
            (Expression::Identifier(box Node { node: left_id, .. }), Expression::Constant(_)) => {
                Stmts::from(Stmt::Transfer(
                    Exp::NewRessource(Props::from(Prop::Copy)),
                    Exp::Id(left_id.name.to_string()),
                ))
            }
            (
                Expression::Identifier(box Node {
                    node: Identifier { name },
                    ..
                }),
                right,
            ) => {
                let stmts = self.transpile_expression(right);

                match stmts.0.last() {
                    Some(Stmt::Expression(e)) => {
                        Stmts::from(Stmt::Transfer(e.clone(), Exp::Id(name.to_string())))
                    }
                    Some(_) => stmts,
                    None => Stmts::new(),
                }
            }
            (Expression::UnaryOperator(unary), right) => self.transpile_deref(&unary.node, right),
            _ => unimplemented!(),
        }
    }

    pub(super) fn transpile_deref(
        &mut self,
        unary: &UnaryOperatorExpression,
        right: &Expression,
    ) -> Stmts {
        match (&unary.operator.node, &unary.operand.node, right) {
            (UnaryOperator::Indirection, Expression::Identifier(box Node { node, .. }), right) => {
                let mut stmts = self.transpile_expression(right);
                stmts
                    .0
                    .push(Stmt::Expression(Exp::Deref(box Exp::Id(node.name.clone()))));
                stmts
            }
            _ => Stmts::new(),
        }
    }
}
