use lang_c::ast::*;
use lang_c::span;
use lang_c::span::Node;
use enum_extract::extract;

mod context;
mod utils;

use crate::ast::*;
use crate::transpiler::context::*;
use crate::transpiler::utils::*;


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
            _ => unimplemented!(),
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

    pub fn transpile_statement<'ast>(&mut self, statement: &'ast Statement) -> Stmts {
        match *statement {
            Statement::Expression(Some(ref e)) => Stmts::from(self.transpile_expression(&e.node)),
            Statement::Return(Some(ref r)) => Stmts::from(self.transpile_return_statement(&r.node)),
            Statement::Compound(ref block_items) => self.transpile_block_items(block_items),
            _ => unimplemented!(),
        }
    }

    fn transpile_expression(&mut self, exp: &Expression) -> Stmt {
        match exp {
            Expression::Identifier(box Node {
                node: Identifier { name },
                ..
            }) => Stmt::Expression(Exp::Id(name.to_string())),
            Expression::Call(box Node { node: call, .. }) => {
                Stmt::Expression(self.transpile_call_expression(&call))
            }
            Expression::BinaryOperator(box Node { node: bin_op, .. }) => {
                self.transpile_binary_operator(bin_op)
            }
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
            .map(|exp| self.transpile_expression(&exp))
            .map(|exp| extract!(Stmt::Expression(_), exp).unwrap())
            .collect::<Vec<Exp>>();
        Exp::Call(callee, Exps(arguments))
    }

    fn transpile_binary_operator(&mut self, bop: &BinaryOperatorExpression) -> Stmt {
        let left = &bop.lhs.node;
        let right = &bop.rhs.node;
        let operator = &bop.operator.node;

        match (left, operator, right) {
            // Basic assignment a = b;
            (
                Expression::Identifier(box Node { node: left_id, .. }),
                BinaryOperator::Assign,
                Expression::Identifier(box Node { node: right_id, .. }),
            ) => self.transpile_assignment(left_id, right_id),
            // Address assignment a = &b;
            // We should consider this as a borrow
            (
                Expression::Identifier(box Node { node: left_id, .. }),
                BinaryOperator::Assign,
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
            ) => self.transpile_ref_assignment(left_id, right_id),
            _ => unimplemented!(),
        }
    }

    fn transpile_assignment(&mut self, lhs: &Identifier, rhs: &Identifier) -> Stmt {
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

        // create the AST Stmt node
        match decl_mut {
            Mutability::ImmOwner => Stmts(
                ids.into_iter()
                    .map(|id| Stmt::Declaration(id, Some(Type::Own(Props(vec![])))))
                    .collect(),
            ),
            Mutability::MutOwner => Stmts(
                ids.into_iter()
                    .map(|id| Stmt::Declaration(id, Some(Type::Own(Props(vec![Prop::Mut])))))
                    .collect(),
            ),
            Mutability::ImmRef | Mutability::MutRef => Stmts(
                ids.into_iter()
                    .map(|id| Stmt::Declaration(id, None))
                    .collect(),
            ),
        }
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
            None => panic!("no function definition can't be retrieve for this return statement"),
        }
    }
}
