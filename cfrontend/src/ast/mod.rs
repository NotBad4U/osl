use std::{fmt, ops};

pub mod render;

type Id = String;
type LifetimeMarker = String;

#[derive(Debug, Clone)]
pub struct Parameter(pub Id, pub Type);

#[derive(Debug, Clone)]
pub struct Parameters(pub Vec<Parameter>);

impl Parameters {
    pub fn new() -> Self {
        Self(vec![])
    }
}

impl ops::Deref for Parameters {
    type Target = Vec<Parameter>;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

impl From<Parameter> for Parameters {
    fn from(parameter: Parameter) -> Self {
        Parameters(vec![parameter])
    }
}

impl Parameter {
    pub fn new(id: &str, r#type: Type) -> Self {
        Self(id.to_string(), r#type)
    }
}

impl From<Vec<Parameter>> for Parameters {
    fn from(parameters: Vec<Parameter>) -> Self {
        Parameters(parameters)
    }
}

#[derive(Debug, Clone)]
pub struct Blocks(pub Vec<Stmts>);

impl ops::Deref for Blocks {
    type Target = Vec<Stmts>;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

#[derive(Debug, Clone)]
pub enum Stmt {
    Comment(String),
    Declaration(Id),
    Function(Id, Parameters, Type, Stmts),
    Transfer(Exp, Exp),
    Val(Exp),
    Borrow(Exp, Exp),
    MBorrow(Exp, Exp),
    Expression(Exp),
    Branch(Blocks),
    Loop(Stmts),
    Deallocate(Exp),
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

impl Stmts {
    pub fn new() -> Self {
        Self(vec![])
    }
}

#[derive(Debug, Clone)]
pub enum Type {
    Own(Props),
    Ref(LifetimeMarker, Box<Type>),
    VoidTy,
}

impl Type {
    pub fn own() -> Self {
        Type::Own(Props::new())
    }

    pub fn own_from(props: Props) -> Self {
        Type::Own(props)
    }

    pub fn ref_from(lifetime: &str, r#type: Type) -> Self {
        Type::Ref(lifetime.to_string(), box r#type)
    }
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

impl From<Vec<Prop>> for Props {
    fn from(props: Vec<Prop>) -> Self {
        let props: Vec<Prop> = props.iter().cloned().collect();
        Props(props)
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
    Deref(Box<Exp>),
    Read(Box<Exp>),
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
