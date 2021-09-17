use super::*;
use crate::node;

impl Transpiler {
    pub(super) fn transpile_while_statement(
        &mut self,
        while_stmt: &WhileStatement,
    ) -> Result<Stmts> {
        let condition = self
            .transpile_expression(&while_stmt.expression.node)?
            .into();
        let block = self.transpile_statement(&while_stmt.statement)?;

        // construct AST
        let mut stmts = Stmts::from(Stmt::Comment("loop invariant".into()));
        stmts.append(condition);
        stmts.push(Stmt::Loop(block));
        Ok(stmts)
    }

    pub(super) fn transpile_dowhile_statement(
        &mut self,
        while_stmt: &DoWhileStatement,
    ) -> Result<Stmts> {
        let condition = self
            .transpile_expression(&while_stmt.expression.node)?
            .into();
        let mut block = self.transpile_statement(&while_stmt.statement)?;
        block.extend(condition);
        Ok(Stmts::from(Stmt::Loop(block)))
    }

    pub(super) fn transpile_forloop_statement(&mut self, forloop: &ForStatement) -> Result<Stmts> {
        let condition = forloop
            .condition
            .as_ref()
            .map(|box node!(cond)| self.transpile_expression(cond).map(Into::into))
            .unwrap_or(Ok(Stmts::new()))?;

        let initializer = match &forloop.initializer.node {
            ForInitializer::Empty => Ok(Stmts::new()),
            ForInitializer::Expression(box node!(e)) => {
                self.transpile_expression(&e).map(Into::into)
            }
            ForInitializer::Declaration(d) => unimplemented!(), /*self.transpile_declaration(&d)*/
            ForInitializer::StaticAssert(node) => Err(TranspilationError::Unsupported(
                node.span,
                "Static assert are not supported",
            )),
        }?;

        let mut header_of_loop = initializer;
        header_of_loop.append(condition.clone());

        let step_increments = forloop
            .step
            .as_ref()
            .map(|step| self.transpile_expression(&step.node).map(Into::into))
            .unwrap_or(Ok(Stmts::new()))?;

        let mut block_statements = self.transpile_statement(&forloop.statement)?;
        block_statements.append(condition);
        block_statements.append(step_increments);

        let mut statements_for_loop = header_of_loop;
        statements_for_loop.push(Stmt::Loop(block_statements));

        Ok(statements_for_loop)
    }
}
