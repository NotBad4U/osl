use std::{fmt, ops};

mod printer;

type Id = String;

#[derive(Debug)]
pub struct Parameter {}

#[derive(Debug)]
pub struct Stmts(pub Vec<Stmt>);

impl From<Stmt> for Stmts {
    fn from(stmt: Stmt) -> Self {
        Stmts(vec![stmt])
    }
}

#[derive(Debug)]
pub enum Stmt {
    Declaration(Id, Option<Type>),
    Function(Id, Vec<Parameter>, Type,  Stmts),
    Transfer(Exp, Exp),
    Val(Exp),
    Borrow(Exp, Exp),
    MBorrow(Exp, Exp),
}

#[derive(Debug)]
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

#[derive(Debug)]
pub enum Prop {
    Copy,
    Mut,
}

#[derive(Debug)]
pub struct Props(pub Vec<Prop>);

impl ops::Deref for Props {
    type Target = Vec<Prop>;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}


#[derive(Debug)]
pub enum Exp {
    NewRessource(Props),
    Id(String),
}
