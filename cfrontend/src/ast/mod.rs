use std::{fmt, ops};

mod printer;

type Id = String;

#[derive(Debug, Clone)]
pub struct Parameter {}

#[derive(Debug, Clone)]
pub struct Stmts(pub Vec<Stmt>);

impl From<Stmt> for Stmts {
    fn from(stmt: Stmt) -> Self {
        Stmts(vec![stmt])
    }
}

#[derive(Debug, Clone)]
pub enum Stmt {
    Declaration(Id, Option<Type>),
    Function(Id, Vec<Parameter>, Type,  Stmts),
    Transfer(Exp, Exp),
    Val(Exp),
    Borrow(Exp, Exp),
    MBorrow(Exp, Exp),
}

#[derive(Debug, Clone)]
pub enum Type {
    Own(Props),
    //Ref(Lifetime, Box<Type>),
    VoidTy,
}

impl ops::Deref for Stmts {
    type Target = Vec<Stmt>;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

#[derive(Debug, Clone)]
pub enum Prop {
    Copy,
    Mut,
}

#[derive(Debug, Clone)]
pub struct Props(pub Vec<Prop>);

impl ops::Deref for Props {
    type Target = Vec<Prop>;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}


#[derive(Debug, Clone)]
pub enum Exp {
    NewRessource(Props),
    Id(String),
}
