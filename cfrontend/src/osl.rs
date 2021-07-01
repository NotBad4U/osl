use lang_c::ast::*;
use lang_c::span;
use lang_c::span::Node;

use std::{fmt, ops};

use crate::context::*;

type Id = String;

#[derive(Debug)]
pub struct Parameter {}

#[derive(Debug)]
pub struct Stmts(pub Vec<Stmt>);

#[derive(Debug)]
pub enum Stmt {
    Function(Id, Vec<Parameter>, Stmts),
    Val(Exp),
}

impl ops::Deref for Stmts {
    type Target = Vec<Stmt>;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

impl fmt::Display for Stmts {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        self.iter().fold(Ok(()), |result, stmt| {
            result.and_then(|_| writeln!(f, "{}", stmt))
        })
    }
}

impl fmt::Display for Stmt {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Stmt::Function(id, _params, stmts) => {
                writeln!(f, "fn {}() {{", id).unwrap();
                write!(f, "\t{}", stmts).unwrap();
                writeln!(f, "}}")
            }
            Stmt::Val(exp) => {
                writeln!(f, "val({})", exp)
            }
        }
    }
}

#[derive(Debug)]
pub enum Prop {
    Copy,
    Mut,
}

impl fmt::Display for Prop {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            Prop::Mut => write!(f, "mut"),
            Prop::Copy => write!(f, "copy"),
        }
    }
}

#[derive(Debug)]
pub struct Props(Vec<Prop>);

impl ops::Deref for Props {
    type Target = Vec<Prop>;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

impl fmt::Display for Props {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        self.iter().fold(Ok(()), |result, prop| {
            result.and_then(|_| write!(f, "{},", prop))
        })
    }
}

#[derive(Debug)]
pub enum Exp {
    NewRessource(Props),
}

impl fmt::Display for Exp {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            Exp::NewRessource(props) => write!(f, "newResource({})", props),
        }
    }
}

#[derive(Debug)]
pub struct Transformer {
    pub stmts: Vec<Stmt>,
    context: MutabilityContext,
}

impl Transformer {
    pub fn new() -> Self {
        Self {
            stmts: Vec::new(),
            context: MutabilityContext::new(),
        }
    }

    pub fn transform_translation_unit<'ast>(&mut self, translation_unit: &'ast TranslationUnit) {
        for element in &translation_unit.0 {
            debug!("{:#?}", element.node);
            self.transform_external_declaration(&element.node, &element.span);
        }
    }

    pub fn transform_function_def<'ast>(&mut self, function_def: &'ast FunctionDefinition) {
        self.context.create_new_scope();

        // Extract ownership information from the function definition

        let fn_id = match function_def.declarator.node.kind.node {
            DeclaratorKind::Identifier(ref i) => i.node.name.to_string(),
            _ => panic!("function without identifier"),
        };

        let mut_return_type = get_return_fun_mutability_from_fun_def(function_def);

        self.context.insert_in_last_scope(
            fn_id.clone(),
            MutabilityContextItem::Function(mut_return_type),
        );

        // Inductive recursion on the compound statements
        let block_stmts = transform_statement(&mut self.context, &function_def.statement.node);

        // Create the AST OSL corresponding node
        self.stmts.push(Stmt::Function(fn_id, vec![], block_stmts));
        self.context.pop_last_scope();
    }

    pub fn transform_external_declaration<'ast>(
        &mut self,
        external_declaration: &'ast ExternalDeclaration,
        _span: &'ast span::Span,
    ) {
        match *external_declaration {
            ExternalDeclaration::FunctionDefinition(ref f) => {
                self.transform_function_def(&f.node);
            }
            _ => {}
        }
    }
}

pub fn transform_statement<'ast>(
    context: &mut MutabilityContext,
    statement: &'ast Statement,
) -> Stmts {
    match *statement {
        Statement::Return(Some(ref r)) => Stmts(vec![transform_return_statement(context, &r.node)]),
        Statement::Compound(ref block_items) => transform_block_items(context, block_items),
        _ => unimplemented!(),
    }
}

fn transform_block_items(
    context: &mut MutabilityContext,
    block_items: &Vec<Node<BlockItem>>,
) -> Stmts {
    block_items
        .iter()
        .fold(Stmts(Vec::new()), |mut acc, item| match item {
            Node {
                node: BlockItem::Statement(Node { node: stmt, .. }),
                ..
            } => {
                let mut stmts = transform_statement(context, stmt);
                acc.0.append(&mut stmts.0);
                acc
            }
            _ => unimplemented!(),
        })
}

fn transform_return_statement(context: &mut MutabilityContext, _exp: &Expression) -> Stmt {
    let mut_return_type = context.get_last_function_mutability();

    match mut_return_type {
        Some(mut_r) => match mut_r {
            (_, Mutability::ImmOwner) => Stmt::Val(Exp::NewRessource(Props(vec![Prop::Copy]))),
            (_, Mutability::MutOwner) => Stmt::Val(Exp::NewRessource(Props(vec![]))),
            _ => unimplemented!(),
        },
        // This should not happend because the parser if the parser work correctly, so I put this as a guard
        None => panic!("no function definition can't be retrieve for this return statement"),
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

#[cfg(test)]
mod test_osl_transform {
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
