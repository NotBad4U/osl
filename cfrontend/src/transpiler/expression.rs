use super::*;

impl Transpiler {
    pub(super) fn transpile_expression(&mut self, exp: &Expression) -> Stmts {
        match exp {
            Expression::Identifier(box Node {
                node: Identifier { name },
                ..
            }) => Stmts::from(Stmt::Expression(Exp::Id(name.to_string()))),
            Expression::Call(box Node { node: call, .. }) => {
                Stmts::from(Stmt::Expression(self.transpile_call_expression(&call)))
            }
            Expression::BinaryOperator(box Node { node: bin_op, .. }) => {
                self.transpile_binary_operator(bin_op)
            }
            Expression::Constant(_) => Stmts::new(),
            e => unimplemented!("{:?}", e),
        }
    }

    pub(super) fn transpile_call_expression(&mut self, call_exp: &CallExpression) -> Exp {
        let callee = extract!(Expression::Identifier(_), &call_exp.callee.node)
            .unwrap()
            .node
            .name
            .to_string();
        let arguments = call_exp
            .arguments
            .iter()
            .map(|node| &node.node)
            .map(|exp| self.transpile_expression(&exp).first().unwrap().clone()) //FIXME: pb with multiple stat
            .map(|exp| extract!(Stmt::Expression(_), exp).unwrap())
            .collect::<Vec<Exp>>();
        Exp::Call(callee, Exps(arguments))
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
            // Basic assignment a = b;
            (
                Expression::Identifier(box Node { node: left_id, .. }),
                Expression::Identifier(box Node { node: right_id, .. }),
            ) => Stmts::from(self.transpile_semantic_move(left_id, right_id)),
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
            (Expression::Identifier(_), right) => self.transpile_expression(right),
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