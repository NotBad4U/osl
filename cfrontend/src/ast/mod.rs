use std::{fmt, ops};

mod printer;

type Id = String;
type LifetimeMarker = String;

#[derive(Debug, Clone)]
pub struct Parameter(pub Id, pub Type);

#[derive(Debug, Clone)]
pub struct Parameters(pub Vec<Parameter>);

impl ops::Deref for Parameters {
    type Target = Vec<Parameter>;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

#[derive(Debug, Clone)]
pub enum Stmt {
    Declaration(Id, Option<Type>),
    Function(Id, Parameters, Type, Stmts),
    Transfer(Exp, Exp),
    Val(Exp),
    Borrow(Exp, Exp),
    MBorrow(Exp, Exp),
    Expression(Exp),
    Branch(Stmts),
}

#[derive(Debug, Clone)]
pub struct Stmts(pub Vec<Stmt>);

impl From<Stmt> for Stmts {
    fn from(stmt: Stmt) -> Self {
        Stmts(vec![stmt])
    }
}

impl ops::Deref for Stmts {
    type Target = Vec<Stmt>;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

#[derive(Debug, Clone)]
pub enum Type {
    Own(Props),
    Ref(LifetimeMarker, Box<Type>),
    VoidTy,
}

#[derive(Debug, Clone)]
pub enum Prop {
    Copy,
    Mut,
}

#[derive(Debug, Clone)]
pub struct Props(pub Vec<Prop>);

impl Props {
    pub fn new() -> Self {
        Self(vec![])
    }
}

impl From<Prop> for Props {
    fn from(prop: Prop) -> Self {
        Props(vec![prop])
    }
}

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
    Call(String, Exps),
}

/// Only for function arguments call
#[derive(Debug, Clone)]
pub struct Exps(pub Vec<Exp>);

impl ops::Deref for Exps {
    type Target = Vec<Exp>;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

impl From<Exp> for Exps {
    fn from(exp: Exp) -> Self {
        Exps(vec![exp])
    }
}
