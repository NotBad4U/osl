use std::collections::HashMap;

use lang_c::ast::*;
use lang_c::span;

type Id = String;

#[derive(Debug)]
pub struct Parameter {}

type Block = Vec<Stmt>;

#[derive(Debug)]
pub enum Stmt {
    Function(Id, Vec<Parameter>, Block),
}

#[derive(Debug)]
pub struct Transformer {
    pub stmts: Vec<Stmt>,
}

impl Transformer {
    pub fn new() -> Self {
        Self { stmts: Vec::new() }
    }

    pub fn transform_translation_unit<'ast>(&mut self, translation_unit: &'ast TranslationUnit) {
        for element in &translation_unit.0 {
            self.transform_external_declaration(&element.node, &element.span);
        }
    }

    pub fn transform_function_def<'ast>(&mut self, function_def: &'ast FunctionDefinition) {
        debug!("{:#?}", function_def);

        let fn_id = match function_def.declarator.node.kind.node {
            DeclaratorKind::Identifier(ref i) => i.node.name.to_string(),
            _ => panic!("function without identifier"),
        };

        let stmts = transform_statement(&function_def.statement.node);
        self.stmts.push(Stmt::Function(fn_id, vec![], stmts));
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

pub fn transform_statement<'ast>(statement: &'ast Statement) -> Vec<Stmt> {
    let stmts = Vec::new();

    match *statement {
        Statement::Compound(ref c) => for item in c {},
        Statement::Return(Some(ref r)) => {}
        _ => {}
    };

    stmts
}
