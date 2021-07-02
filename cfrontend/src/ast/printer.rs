use super::*;

impl fmt::Display for Stmts {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        self.iter().fold(Ok(()), |result, stmt| {
            result.and_then(|_| writeln!(f, "{}", stmt))
        })
    }
}

impl fmt::Display for Stmt {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Stmt::Declaration(id, None) => {
               writeln!(f, "decl {};", id)
            }
            Stmt::Declaration(id, Some(r#type)) => {
                writeln!(f, "decl {}: {};", id, r#type)
            }
            Stmt::Function(id, _params, return_type,  stmts) => {
                writeln!(f, "fn {}() -> {} {{", id, return_type).unwrap();
                write!(f, "\t{}", stmts).unwrap();
                writeln!(f, "}}")
            }
            Stmt::Val(exp) => {
                writeln!(f, "val({})", exp)
            }
        }
    }
}

impl fmt::Display for Type {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Type::Own(props) => write!(f, "#own({})", props),
            Type::VoidTy => write!(f, "#voidTy"),

        }
    }
}


impl fmt::Display for Prop {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            Prop::Mut => write!(f, "mut"),
            Prop::Copy => write!(f, "copy"),
        }
    }
}

impl fmt::Display for Props {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        self.iter().fold(Ok(()), |result, prop| {
            result.and_then(|_| write!(f, "{},", prop))
        })
    }
}

impl fmt::Display for Exp {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            Exp::NewRessource(props) => write!(f, "newResource({})", props),
        }
    }
}
