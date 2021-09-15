use super::*;

impl Transpiler {
    pub(super) fn transpile_while_statement(&mut self, while_stmt: &WhileStatement) -> Stmts {
        let condition = self.transpile_normalized_expression(&while_stmt.expression.node);
        let mut block = self.transpile_statement(&while_stmt.statement.node);

        block.push(Stmt::Comment("loop invariant".into()));
        block.extend(condition.clone());

        let mut stmts = condition;
        stmts.push(Stmt::Loop(block));
        stmts
    }

    pub(super) fn transpile_dowhile_statement(&mut self, while_stmt: &DoWhileStatement) -> Stmts {
        let condition = self.transpile_normalized_expression(&while_stmt.expression.node);

        let mut block = self.transpile_statement(&while_stmt.statement.node);
        block.extend(condition);

        Stmts::from(Stmt::Loop(block))
    }

    pub(super) fn transpile_forloop_statement(&mut self, forloop_stmt: &ForStatement) -> Stmts {
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
            .map(|cond| self.transpile_normalized_expression(&cond.node))
            .unwrap_or(Stmts::new());

        let mut block = self.transpile_statement(&forloop_stmt.statement.node);

        let step = forloop_stmt
            .step
            .as_ref()
            .map(|step| self.transpile_expression(&step.node))
            .unwrap_or(Stmts::new());
        block.extend(step);

        stmts.push(Stmt::Comment("loop init".into()));
        stmts.extend(initializer);

        stmts.push(Stmt::Comment("loop invariant".into()));
        stmts.extend(condition.clone());

        block.push(Stmt::Comment("loop invariant".into()));
        block.extend(condition);
        stmts.push(Stmt::Loop(block));

        stmts
    }
}
