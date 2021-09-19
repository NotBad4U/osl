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

    pub fn push(&mut self, parameter: Parameter) {
        self.0.push(parameter)
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

impl Blocks {
    pub fn push(&mut self, stmts: Stmts) {
        self.0.push(stmts)
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
    Unsafe(Stmts),
    // We add this statement that is not in the original
    // OSL syntax for simplify the transpilation work
    Return(Exp),
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

    pub fn get(&self) -> &Vec<Stmt> {
        &self.0
    }

    pub fn push(&mut self, stmt: Stmt) {
        self.0.push(stmt)
    }

    pub fn append(&mut self, mut stmts: Stmts) {
        self.0.append(&mut stmts.0)
    }

    pub fn extend(&mut self, stmts: Stmts) {
        self.0.extend(stmts.0.into_iter())
    }
}

#[derive(Debug, Clone, PartialEq)]
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

#[derive(Debug, Clone, PartialEq, Eq, Hash, PartialOrd, Ord)]
pub enum Prop {
    Copy,
    Mut,
}

#[derive(Debug, Clone, PartialEq)]
pub struct Props(pub Vec<Prop>);

impl Props {
    pub fn new() -> Self {
        Self(vec![])
    }

    pub fn get_all_props() -> Self {
        Self(vec![Prop::Mut, Prop::Copy])
    }

    pub fn push(&mut self, prop: Prop) {
        self.0.push(prop)
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
    NewResource(Props),
    Id(String),
    Call(String, Exps),
    Deref(Box<Exp>),
    Read(Box<Exp>),
    Write(Box<Exp>, Box<Exp>),
    Unit,
    /// use for borrow and mborrow
    Statement(Box<Stmt>),
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
