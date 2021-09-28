use super::*;

impl Transpiler {
    /// Transpile an If - Else (optional) statement recursively
    pub(super) fn transpile_branchs(&mut self, if_stmt: &IfStatement) -> Result<Stmts> {
        self.context.create_new_scope();

        let condition_result: Result<Stmts> = self
            .transpile_condition_expression(&if_stmt.condition.node)
            .map(Into::into);

        let (then_statements, else_statements) = self
            .transpile_statement(&if_stmt.then_statement)
            .and_then(|then_statements| {
                match if_stmt
                    .else_statement
                    .as_ref()
                    .map(|ref else_branch| self.transpile_statement(&else_branch))
                    .unwrap_or(Ok(Stmts::new()))
                {
                    Ok(else_statements) => Ok((then_statements, else_statements)),
                    Err(e) => Err(e),
                }
            })?;

        self.context.pop_last_scope();

        condition_result.and_then(|mut condition_statement| {
            let blocks = if else_statements.is_empty() {
                vec![then_statements]
            } else {
                vec![then_statements, else_statements]
            };
            condition_statement.push(Stmt::Branch(Blocks(blocks)));
            Ok(condition_statement)
        })
    }
}
