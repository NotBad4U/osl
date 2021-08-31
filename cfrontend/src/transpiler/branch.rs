use super::*;

impl Transpiler {
    /// Transpiled an If statement
    /// The Then and Else statement are transpiled as Stmts (Block) and put in a Blocks
    pub(super) fn transpile_branchs(&mut self, if_stmt: &IfStatement) -> Stmts {
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

        let mut stmts = self.transpile_normalized_expression(&if_stmt.condition.node);
        stmts.0.push(Stmt::Branch(blocks));
        stmts
    }
}
