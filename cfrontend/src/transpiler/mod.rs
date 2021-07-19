use enum_extract::extract;
use lang_c::ast::*;
use lang_c::span;
use lang_c::span::Node;

mod context;
mod diagnostic;
mod utils;

use crate::ast::*;

use context::*;
use diagnostic::CodespanReporter;
use utils::*;

#[derive(Debug)]
pub struct Transpiler {
    pub stmts: Vec<crate::ast::Stmt>,
    context: MutabilityContext,
}

impl Transpiler {
    pub fn new() -> Self {
        Self {
            stmts: Vec::new(),
            context: MutabilityContext::new(),
        }
    }

    pub fn transpile_translation_unit<'ast>(&mut self, translation_unit: &'ast TranslationUnit) {
        for element in &translation_unit.0 {
            self.transpile_external_declaration(&element.node, &element.span);
        }

        // append the call to C main function
        self.stmts.push(Stmt::Expression(Exp::Call(
            "main".to_string(),
            Exps(vec![]),
        )));
    }

    pub fn transpile_function_def<'ast>(&mut self, function_def: &'ast FunctionDefinition) {
        self.context.create_new_scope();

        // Extract ownership information from the function definition
        let fn_id = get_declarator_id(&function_def.declarator.node).unwrap();
        let mut_return_type = get_return_fun_mutability_from_fun_def(function_def);

        self.context.insert_in_last_scope(
            fn_id.clone(),
            MutabilityContextItem::Function(mut_return_type.clone()),
        );

        // Inductive recursion on the compound statements
        let block_stmts = self.transpile_statement(&function_def.statement.node);

        // Create the AST OSL corresponding node
        self.stmts.push(Stmt::Function(
            fn_id,
            self.transpile_parameters_declaration(&get_function_parameters_from_declarator(
                &function_def.declarator.node,
            )),
            convert_mutability_to_type(&mut_return_type),
            block_stmts,
        ));

        self.context.pop_last_scope();
    }

    pub fn transpile_external_declaration<'ast>(
        &mut self,
        external_declaration: &'ast ExternalDeclaration,
        _span: &'ast span::Span,
    ) {
        match *external_declaration {
            ExternalDeclaration::FunctionDefinition(ref f) => {
                self.transpile_function_def(&f.node);
            }
            ExternalDeclaration::Declaration(ref d) => {
                let stmts = self.transpile_declaration(&d.node);
                self.stmts.extend(stmts.0);
            }
            ExternalDeclaration::StaticAssert(Node { span, .. }) => {
                unimplemented!()
            }
        }
    }

    fn transpile_parameters_declaration(&self, params: &Vec<ParameterDeclaration>) -> Parameters {
        params
            .iter()
            .fold(Parameters(Vec::new()), |mut acc, param| {
                acc.0.push(self.transpile_parameter_declaration(param));
                acc
            })
    }

    fn transpile_parameter_declaration(&self, param: &ParameterDeclaration) -> Parameter {
        let declarator = &param.declarator.as_ref().unwrap().node;
        let id = get_declarator_id(&declarator).unwrap();

        let mutability = if is_a_ref(declarator) {
            if is_a_ref_const(declarator) {
                Mutability::ImmRef
            } else {
                Mutability::MutRef
            }
        } else {
            if is_const(param.specifiers.as_slice()) {
                Mutability::ImmOwner
            } else {
                Mutability::MutOwner
            }
        };

        match mutability {
            Mutability::MutOwner => Parameter(id, Type::Own(Props::from(Prop::Mut))),
            Mutability::ImmOwner => Parameter(id, Type::Own(Props::new())),
            Mutability::MutRef => Parameter(
                id,
                Type::Ref("a".into(), box Type::Own(Props::from(Prop::Mut))),
            ),
            Mutability::ImmRef => Parameter(id, Type::Ref("a".into(), box Type::Own(Props::new()))),
        }
    }

    pub fn transpile_statement(&mut self, statement: &Statement) -> Stmts {
        match *statement {
            Statement::Expression(Some(ref e)) => Stmts::from(self.transpile_expression(&e.node)),
            Statement::Return(Some(ref r)) => Stmts::from(self.transpile_return_statement(&r.node)),
            Statement::Compound(ref block_items) => self.transpile_block_items(block_items),
            Statement::If(Node {
                node: ref if_stmt, ..
            }) => self.transpile_branchs(if_stmt),
            Statement::While(ref while_stmt) => self.transpile_while_statement(&while_stmt.node),
            Statement::For(ref forloop) => self.transpile_forloop_statement(&forloop.node),
            Statement::DoWhile(ref dowhile) => self.transpile_dowhile_statement(&dowhile.node),
            _ => unimplemented!(),
        }
    }

    fn transpile_while_statement(&mut self, while_stmt: &WhileStatement) -> Stmts {
        let condition = self.transpile_expression(&while_stmt.expression.node);
        let block = self.transpile_statement(&while_stmt.statement.node);

        let mut stmts = condition;
        stmts.0.push(Stmt::Loop(block));
        stmts
    }

    fn transpile_dowhile_statement(&mut self, while_stmt: &DoWhileStatement) -> Stmts {
        let condition = self.transpile_expression(&while_stmt.expression.node);

        let mut block = self.transpile_statement(&while_stmt.statement.node);
        block.0.extend(condition.0);

        Stmts::from(Stmt::Loop(block))
    }

    fn transpile_forloop_statement(&mut self, forloop_stmt: &ForStatement) -> Stmts {
        let mut stmts = Stmts::new();

        let initializer = match &forloop_stmt.initializer.node {
            ForInitializer::Empty => Stmts::new(),
            ForInitializer::Expression(e) => self.transpile_expression(&e.node),
            ForInitializer::Declaration(d) => self.transpile_declaration(&d.node),
            ForInitializer::StaticAssert(_) => unimplemented!(),
        };

        let condition = forloop_stmt
            .condition
            .as_ref()
            .map(|cond| self.transpile_expression(&cond.node))
            .unwrap_or(Stmts::new());

        let mut block = self.transpile_statement(&forloop_stmt.statement.node);

        let step = forloop_stmt
            .step
            .as_ref()
            .map(|step| self.transpile_expression(&step.node))
            .unwrap_or(Stmts::new());
        block.0.extend(step.0);

        stmts.0.extend(initializer.0);
        stmts.0.extend(condition.0);
        stmts.0.push(Stmt::Loop(block));

        stmts
    }

    fn transpile_expression(&mut self, exp: &Expression) -> Stmts {
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

    fn transpile_call_expression(&mut self, call_exp: &CallExpression) -> Exp {
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

    fn transpile_binary_operator(&mut self, bop: &BinaryOperatorExpression) -> Stmts {
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
    fn transpile_mutable_assign_expression(&mut self, right: &Expression) -> Stmts {
        self.transpile_expression(right)
    }

    fn transpile_boolean_condition_expression(
        &mut self,
        left: &Expression,
        right: &Expression,
    ) -> Stmts {
        let mut stmts = self.transpile_expression(left);
        stmts.0.extend(self.transpile_expression(right).0);
        stmts
    }

    fn transpile_assign_expression(&mut self, left: &Expression, right: &Expression) -> Stmts {
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

    fn transpile_deref(&mut self, unary: &UnaryOperatorExpression, right: &Expression) -> Stmts {
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

    fn transpile_semantic_move(&mut self, lhs: &Identifier, rhs: &Identifier) -> Stmt {
        let left_mut = self
            .context
            .get_variable_mutability(lhs.name.as_str())
            .unwrap_or_else(|| {
                panic!(
                    "The variable {} has not been catched by the transpiler during processing",
                    lhs.name.as_str()
                )
            });
        self.context
            .get_variable_mutability(rhs.name.as_str())
            .unwrap_or_else(|| {
                panic!(
                    "The variable {} has not been catched by the transpiler during processing",
                    rhs.name.as_str()
                )
            });

        match left_mut {
            Mutability::ImmOwner => {
                Stmt::Transfer(Exp::NewRessource(Props(vec![])), Exp::Id(lhs.name.clone()))
            }
            Mutability::MutOwner => Stmt::Transfer(
                Exp::NewRessource(Props(vec![Prop::Mut])),
                Exp::Id(lhs.name.clone()),
            ),
            Mutability::ImmRef => Stmt::Transfer(
                Exp::NewRessource(Props(vec![Prop::Mut])),
                Exp::Id(lhs.name.clone()),
            ),
            Mutability::MutRef => Stmt::Transfer(
                Exp::NewRessource(Props(vec![Prop::Mut])),
                Exp::Id(lhs.name.clone()),
            ),
        }
    }

    fn transpile_ref_assignment(&mut self, lhs: &Identifier, rhs: &Identifier) -> Stmt {
        let left_mut = self
            .context
            .get_variable_mutability(lhs.name.as_str())
            .unwrap_or_else(|| {
                panic!(
                    "The variable {} has not been catched by the transpiler during processing",
                    lhs.name.as_str()
                )
            });
        self.context
            .get_variable_mutability(rhs.name.as_str())
            .unwrap_or_else(|| {
                panic!(
                    "The variable {} has not been catched by the transpiler during processing",
                    rhs.name.as_str()
                )
            });

        match left_mut {
            Mutability::ImmRef => {
                Stmt::Borrow(Exp::Id(lhs.name.clone()), Exp::Id(rhs.name.clone()))
            }
            Mutability::MutRef => {
                Stmt::MBorrow(Exp::Id(lhs.name.clone()), Exp::Id(rhs.name.clone()))
            }
            _ => panic!("This should be a reference"),
        }
    }

    /// Transpile a list of statement in a block
    fn transpile_block_items(&mut self, block_items: &Vec<Node<BlockItem>>) -> Stmts {
        let stmts = block_items
            .iter()
            .fold(Vec::<Stmt>::new(), |mut acc, item| {
                acc.append(&mut match item.node {
                    BlockItem::Statement(Node { node: ref stmt, .. }) => {
                        self.transpile_statement(stmt).0
                    }
                    BlockItem::Declaration(ref declaration) => {
                        self.transpile_declaration(&declaration.node).0
                    }
                    _ => unimplemented!(),
                });
                acc
            });

        Stmts(stmts)
    }

    /// This function return a Stmts because it is possible to declare multiple variables with same type in one line
    fn transpile_declaration(&mut self, declaration: &Declaration) -> Stmts {
        let decl_mut = get_mutability_of_declaration(declaration);

        // get the list of identifiers
        // T a = x, b = x => [a, b]
        let ids: Vec<String> = declaration
            .declarators
            .iter()
            .map(
                |Node {
                     node: InitDeclarator { declarator, .. },
                     ..
                 }| get_declarator_id(&declarator.node).unwrap(),
            )
            .collect();

        // store the new variables in the context map
        ids.iter().for_each(|id| {
            self.context
                .insert_in_last_scope(id, MutabilityContextItem::Variable(decl_mut.clone()))
        });

        Stmts(
            ids.into_iter()
                .map(|id| Stmt::Declaration(id, None))
                .collect(),
        )
    }

    fn transpile_return_statement(&mut self, _exp: &Expression) -> Stmt {
        let mut_return_type = self.context.get_last_function_mutability();

        match mut_return_type {
            Some(mut_r) => match mut_r {
                (_, Mutability::ImmOwner) => Stmt::Val(Exp::NewRessource(Props(vec![]))),
                (_, Mutability::MutOwner) => Stmt::Val(Exp::NewRessource(Props(vec![Prop::Mut]))),
                _ => unimplemented!(),
            },
            // This should not happend because the parser if the parser work correctly, so I put this as a guard
            None => {
                unreachable!("no function definition can't be retrieve for this return statement")
            }
        }
    }

    /// Transpiled an If statement
    /// The Then and Else statement are transpiled as Stmts (Block) and put in a Blocks
    fn transpile_branchs(&mut self, if_stmt: &IfStatement) -> Stmts {
        let mut blocks: Blocks = Blocks(Vec::new());

        blocks
            .0
            .push(self.transpile_statement(&if_stmt.then_statement.node));

        let else_stmts = if_stmt
            .else_statement
            .as_ref()
            .map(|ref else_branch| self.transpile_statement(&else_branch.node))
            .unwrap_or(Stmts::new());

        if !else_stmts.is_empty() {
            blocks.0.push(else_stmts)
        }

        let mut stmts = self.transpile_expression(&if_stmt.condition.node);
        stmts.0.push(Stmt::Branch(blocks));
        stmts
    }
}
