use lang_c::ast::*;
use lang_c::span;
use lang_c::span::Node;

use crate::ast::*;
use crate::context::*;

use enum_extract::extract;

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
        let block_stmts = transpile_statement(&mut self.context, &function_def.statement.node);

        // Create the AST OSL corresponding node
        self.stmts.push(Stmt::Function(
            fn_id,
            transpile_parameters_declaration(&get_function_parameters_from_declarator(
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
}

fn get_function_parameters_from_declarator(declaration: &Declarator) -> Vec<ParameterDeclaration> {
    match &declaration.derived.first().unwrap().node {
        DerivedDeclarator::Function(Node {
            node: FunctionDeclarator { parameters, .. },
            ..
        }) => parameters
            .into_iter()
            .map(|param| param.node.clone())
            .collect(),
        _ => vec![],
    }
}

fn transpile_parameters_declaration(params: &Vec<ParameterDeclaration>) -> Parameters {
    params
        .iter()
        .fold(Parameters(Vec::new()), |mut acc, param| {
            acc.0.push(transpile_parameter_declaration(param));
            acc
        })
}

fn transpile_parameter_declaration(param: &ParameterDeclaration) -> Parameter {
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

pub fn transpile_statement<'ast>(
    context: &mut MutabilityContext,
    statement: &'ast Statement,
) -> Stmts {
    match *statement {
        Statement::Expression(Some(ref e)) => Stmts::from(transpile_expression(context, &e.node)),
        Statement::Return(Some(ref r)) => Stmts::from(transpile_return_statement(context, &r.node)),
        Statement::Compound(ref block_items) => transpile_block_items(context, block_items),
        _ => unimplemented!(),
    }
}

fn transpile_expression(context: &mut MutabilityContext, exp: &Expression) -> Stmt {
    match exp {
        Expression::Identifier(box Node {
            node: Identifier { name },
            ..
        }) => Stmt::Expression(Exp::Id(name.to_string())),
        Expression::Call(box Node { node: call, .. }) => {
            Stmt::Expression(transpile_call_expression(context, &call))
        }
        Expression::BinaryOperator(box Node { node: bin_op, .. }) => {
            transpile_binary_operator(context, bin_op)
        }
        e => unimplemented!("{:?}", e),
    }
}

fn transpile_call_expression(context: &mut MutabilityContext, call_exp: &CallExpression) -> Exp {
    let callee = extract!(Expression::Identifier(_), &call_exp.callee.node)
        .unwrap()
        .node
        .name
        .to_string();
    let arguments = call_exp
        .arguments
        .iter()
        .map(|node| &node.node)
        .map(|exp| transpile_expression(context, &exp))
        .map(|exp| extract!(Stmt::Expression(_), exp).unwrap())
        .collect::<Vec<Exp>>();
    Exp::Call(callee, Exps(arguments))
}

fn transpile_binary_operator(
    context: &mut MutabilityContext,
    bop: &BinaryOperatorExpression,
) -> Stmt {
    let left = &bop.lhs.node;
    let right = &bop.rhs.node;
    let operator = &bop.operator.node;

    match (left, operator, right) {
        // Basic assignment a = b;
        (
            Expression::Identifier(box Node { node: left_id, .. }),
            BinaryOperator::Assign,
            Expression::Identifier(box Node { node: right_id, .. }),
        ) => transpile_assignment(context, left_id, right_id),
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
        ) => transpile_ref_assignment(context, left_id, right_id),
        _ => unimplemented!(),
    }
}

fn transpile_assignment(
    context: &mut MutabilityContext,
    lhs: &Identifier,
    rhs: &Identifier,
) -> Stmt {
    let left_mut = context
        .get_variable_mutability(lhs.name.as_str())
        .unwrap_or_else(|| {
            panic!(
                "The variable {} has not been catched by the transpiler during processing",
                lhs.name.as_str()
            )
        });
    context
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

fn transpile_ref_assignment(
    context: &mut MutabilityContext,
    lhs: &Identifier,
    rhs: &Identifier,
) -> Stmt {
    let left_mut = context
        .get_variable_mutability(lhs.name.as_str())
        .unwrap_or_else(|| {
            panic!(
                "The variable {} has not been catched by the transpiler during processing",
                lhs.name.as_str()
            )
        });
    context
        .get_variable_mutability(rhs.name.as_str())
        .unwrap_or_else(|| {
            panic!(
                "The variable {} has not been catched by the transpiler during processing",
                rhs.name.as_str()
            )
        });

    match left_mut {
        Mutability::ImmRef => Stmt::Borrow(Exp::Id(lhs.name.clone()), Exp::Id(rhs.name.clone())),
        Mutability::MutRef => Stmt::MBorrow(Exp::Id(lhs.name.clone()), Exp::Id(rhs.name.clone())),
        _ => panic!("This should be a reference"),
    }
}

/// Transpile a list of statement in a block
fn transpile_block_items(
    context: &mut MutabilityContext,
    block_items: &Vec<Node<BlockItem>>,
) -> Stmts {
    let stmts = block_items
        .iter()
        .fold(Vec::<Stmt>::new(), |mut acc, item| {
            acc.append(&mut match item.node {
                BlockItem::Statement(Node { node: ref stmt, .. }) => {
                    transpile_statement(context, stmt).0
                }
                BlockItem::Declaration(ref declaration) => {
                    transpile_declaration(context, &declaration.node).0
                }
                _ => unimplemented!(),
            });
            acc
        });

    Stmts(stmts)
}

/// This function return a Stmts because it is possible to declare multiple variables with same type in one line
fn transpile_declaration(context: &mut MutabilityContext, declaration: &Declaration) -> Stmts {
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
        context.insert_in_last_scope(id, MutabilityContextItem::Variable(decl_mut.clone()))
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

fn transpile_return_statement(context: &mut MutabilityContext, _exp: &Expression) -> Stmt {
    let mut_return_type = context.get_last_function_mutability();

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

fn convert_mutability_to_type(mutability: &Mutability) -> Type {
    match mutability {
        Mutability::ImmOwner => Type::Own(Props(vec![])),
        Mutability::MutOwner => Type::Own(Props(vec![Prop::Mut])),
        _ => unimplemented!(),
    }
}

// FIXME: support multiple init declarator
fn get_mutability_of_declaration(declaration: &Declaration) -> Mutability {
    let specifiers = &declaration.specifiers;
    let declarator = &declaration
        .declarators
        .first()
        .unwrap()
        .node
        .declarator
        .node;

    if is_a_ref(declarator) {
        if is_a_ref_const(declarator) {
            Mutability::ImmRef
        } else {
            Mutability::MutRef
        }
    } else {
        if is_const(specifiers) {
            Mutability::ImmOwner
        } else {
            Mutability::MutOwner
        }
    }
}

/// extract the mutability value from a C function definition
fn get_return_fun_mutability_from_fun_def(function_def: &FunctionDefinition) -> Mutability {
    let specifiers = &function_def.specifiers.as_slice();
    let declarator = &function_def.declarator.node;

    if is_a_ref(declarator) {
        if is_a_ref_const(declarator) {
            Mutability::ImmRef
        } else {
            Mutability::MutRef
        }
    } else {
        if is_const(specifiers) {
            Mutability::ImmOwner
        } else {
            Mutability::MutOwner
        }
    }
}

/// Check if the type begin with const type qualifier
/// e.g.: const T *
fn is_const(specifiers: &[Node<DeclarationSpecifier>]) -> bool {
    matches!(
        specifiers,
        [
            Node {
                node: DeclarationSpecifier::TypeQualifier(Node {
                    node: TypeQualifier::Const,
                    ..
                }),
                ..
            },
            ..
        ]
    )
}

/// Check if it is a pointer
/// e.g.: T *
fn is_a_ref(declarator: &Declarator) -> bool {
    matches!(
        declarator.derived.as_slice(),
        [
            Node {
                node: DerivedDeclarator::Pointer(_),
                ..
            },
            ..
        ]
    )
}

/// Check if the pointer is immutable
/// e.g.: T * const
fn is_a_ref_const(declarator: &Declarator) -> bool {
    matches!(
        declarator.derived.as_slice(),
        [Node {
            node: DerivedDeclarator::Pointer(p),
            ..
        },
         ..
        ]
            if matches!(p.as_slice(), [
                    Node{ node: PointerQualifier::TypeQualifier(Node{ node: TypeQualifier::Const, .. }), .. },
                    ..
                ]
            )
    )
}

fn get_declarator_id(decl: &Declarator) -> Option<String> {
    match &decl.kind.node {
        DeclaratorKind::Identifier(Node {
            node: Identifier { ref name },
            ..
        }) => Some(name.to_string()),
        _ => None,
    }
}

#[cfg(test)]
mod test_osl_transpile {
    use super::*;

    use lang_c::driver::parse_preprocessed;
    use lang_c::driver::Config;

    #[test]
    fn it_should_find_a_const_return() {
        let config = Config::default();

        let source = r#"
        const int main() {
            return 0;
        }
        "#
        .to_string();

        let parsed = parse_preprocessed(&config, source).expect("C test code is broken");

        let function = &parsed
            .unit
            .0
            .first()
            .expect("the parser cannot find the main method")
            .node;

        match function {
            ExternalDeclaration::FunctionDefinition(ref f) => {
                assert_eq!(true, is_const(f.node.specifiers.as_slice()));
                assert_eq!(false, is_a_ref(&f.node.declarator.node));
            }
            _ => panic!("expected a function"),
        }
    }

    #[test]
    fn it_should_find_a_ref_to_const_return() {
        let config = Config::default();

        let source = r#"
        const int * main() {
            return 0;
        }
        "#
        .to_string();

        let parsed = parse_preprocessed(&config, source).expect("C test code is broken");

        let function = &parsed
            .unit
            .0
            .first()
            .expect("the parser cannot find the main method")
            .node;

        match function {
            ExternalDeclaration::FunctionDefinition(ref f) => {
                assert_eq!(true, is_const(f.node.specifiers.as_slice()));
                assert_eq!(true, is_a_ref(&f.node.declarator.node));
                assert_eq!(false, is_a_ref_const(&f.node.declarator.node));
            }
            _ => panic!("expected a function"),
        }
    }

    #[test]
    fn it_should_not_find_a_const_return() {
        let config = Config::default();

        let source = r#"
        int main() {
            return 0;
        }
        "#
        .to_string();

        let parsed = parse_preprocessed(&config, source).expect("C test code is broken");

        let function = &parsed
            .unit
            .0
            .first()
            .expect("the parser cannot find the main method")
            .node;

        match function {
            ExternalDeclaration::FunctionDefinition(ref f) => {
                assert_eq!(false, is_const(f.node.specifiers.as_slice()));
                assert_eq!(false, is_a_ref(&f.node.declarator.node));
            }
            _ => panic!("expected a function"),
        }
    }

    #[test]
    fn it_should_not_find_a_const_ref_to_a_const_return() {
        let config = Config::default();

        let source = r#"
        const int * const main() {
            return 0;
        }
        "#
        .to_string();

        let parsed = parse_preprocessed(&config, source).expect("C test code is broken");

        let function = &parsed
            .unit
            .0
            .first()
            .expect("the parser cannot find the main method")
            .node;

        match function {
            ExternalDeclaration::FunctionDefinition(ref f) => {
                assert_eq!(true, is_const(f.node.specifiers.as_slice()));
                assert_eq!(true, is_a_ref(&f.node.declarator.node));
                assert_eq!(true, is_a_ref_const(&f.node.declarator.node));
            }
            _ => panic!("expected a function"),
        }
    }
}
