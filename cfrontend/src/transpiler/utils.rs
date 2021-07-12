use lang_c::ast::*;
use lang_c::span::Node;

use crate::ast::*;
use crate::transpiler::context::Mutability;

pub fn convert_mutability_to_type(mutability: &Mutability) -> Type {
    match mutability {
        Mutability::ImmOwner => Type::Own(Props(vec![])),
        Mutability::MutOwner => Type::Own(Props(vec![Prop::Mut])),
        _ => unimplemented!(),
    }
}

// FIXME: support multiple init declarator
pub fn get_mutability_of_declaration(declaration: &Declaration) -> Mutability {
    let specifiers = &declaration.specifiers;
    let declarator = &declaration
        .declarators
        .first()
        .unwrap()
        .node
        .declarator
        .node;

    if is_a_ref(declarator) {
        if is_const(specifiers) {
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

pub fn get_function_parameters_from_declarator(
    declaration: &Declarator,
) -> Vec<ParameterDeclaration> {
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

/// extract the mutability value from a C function definition
pub fn get_return_fun_mutability_from_fun_def(function_def: &FunctionDefinition) -> Mutability {
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
pub fn is_const(specifiers: &[Node<DeclarationSpecifier>]) -> bool {
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
pub fn is_a_ref(declarator: &Declarator) -> bool {
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
pub fn is_a_ref_const(declarator: &Declarator) -> bool {
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

pub fn get_declarator_id(decl: &Declarator) -> Option<String> {
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
