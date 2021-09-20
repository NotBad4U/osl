use crate::ast::*;

pub trait Visitor {
    fn visit_declaration(&mut self, s: &mut Stmt);
    fn visit_function(&mut self, s: &mut Stmt);
    fn visit_mborrow(&mut self, s: &mut Stmt);
    fn visit_borrow(&mut self, s: &mut Stmt);
    fn visit_transfer(&mut self, s: &mut Stmt);
    fn visit_deallocate(&mut self, s: &mut Stmt);
    fn visit_return(&mut self, s: &mut Stmt);
    fn visit_stmt_expression(&mut self, s: &mut Stmt);
    fn visit_val(&mut self, s: &mut Stmt);

    fn visit_branch(&mut self, s: &mut Stmt) {
        match s {
            Stmt::Branch(Blocks(ref mut blocks)) => self.visit_blocks(blocks),
            _ => unreachable!(),
        }
    }

    fn visit_loop(&mut self, s: &mut Stmt) {
        match s {
            Stmt::Loop(stmts) => self.visit_stmts(stmts),
            _ => unreachable!(),
        }
    }

    fn visit_stmts(&mut self, stmts: &mut Stmts) {
        stmts.0.iter_mut().for_each(|stmt| self.visit_stmt(stmt))
    }

    fn visit_blocks(&mut self, blocks: &mut Vec<Stmts>) {
        blocks.iter_mut().for_each(|stmts| self.visit_stmts(stmts))
    }

    fn visit_stmt(&mut self, s: &mut Stmt) {
        match s {
            Stmt::Branch(..) => self.visit_branch(s),
            Stmt::Loop(..) => self.visit_loop(s),
            Stmt::Deallocate(..) => self.visit_deallocate(s),
            Stmt::Declaration(..) => self.visit_declaration(s),
            Stmt::Function(..) => self.visit_function(s),
            Stmt::Transfer(..) => self.visit_transfer(s),
            Stmt::Borrow(..) => self.visit_borrow(s),
            Stmt::MBorrow(..) => self.visit_mborrow(s),
            Stmt::Return(..) => self.visit_return(s),
            Stmt::Expression(..) => self.visit_stmt_expression(s),
            Stmt::Val(..) => self.visit_val(s),
            Stmt::Unsafe(..) | Stmt::Comment(..) => {}
        }
    }
}
