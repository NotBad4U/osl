use lang_c::ast;
use lang_c::span;
use lang_c::visit;

type Id = String;

#[derive(Debug)]
struct Parameter {}

#[derive(Debug)]
struct Block {
    stmts: Vec<Stmt>,
}

#[derive(Debug)]
enum Stmt {
    Function(Id, Vec<Parameter>, Block),
}

pub struct CVisitorToOsl {}

impl<'ast> visit::Visit<'ast> for CVisitorToOsl {
    fn visit_function_definition(
        &mut self,
        function_definition: &'ast ast::FunctionDefinition,
        span: &'ast span::Span,
    ) {
        info!("{:?}", function_definition.declarator.node.kind);
        visit::visit_function_definition(self, function_definition, span);
    }

    fn visit_declaration(&mut self, decl: &'ast ast::Declaration, span: &'ast span::Span) {
        info!("{:#?}", decl);
        visit::visit_declaration(self, decl, span);
    }

    fn visit_translation_unit(&mut self, translation_unit: &'ast ast::TranslationUnit) {
        visit::visit_translation_unit(self, translation_unit);
    }
}
