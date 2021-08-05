use super::*;

impl fmt::Display for Stmts {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        self.iter().fold(Ok(()), |result, stmt| {
            result.and_then(|_| write!(f, "{}", stmt))
        })
    }
}

impl fmt::Display for Parameters {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        let args_str = self
            .iter()
            .map(|param| format!("{}", param))
            .collect::<Vec<String>>()
            .join(",");
        write!(f, "{}", args_str)
    }
}

impl fmt::Display for Parameter {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{}:{}", self.0, self.1)
    }
}

impl fmt::Display for Blocks {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        let blocks_str = self
            .iter()
            .map(|stmts| format!("{{\n {} \n}}", stmts))
            .collect::<Vec<String>>()
            .join(",");
        write!(f, "{}", blocks_str)
    }
}

impl fmt::Display for Stmt {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Stmt::Declaration(id) => writeln!(f, "decl {};", id),
            Stmt::Function(id, params, return_type, stmts) => {
                writeln!(f, "fn {}({}) -> {} {{", id, params, return_type).unwrap();
                write!(f, "{}", stmts).unwrap();
                writeln!(f, "}}\n")
            }
            Stmt::Val(exp) => writeln!(f, "val({})", exp),
            Stmt::Transfer(e1, e2) => writeln!(f, "transfer {} {};", e1, e2),
            Stmt::MBorrow(e1, e2) => writeln!(f, "{} mborrow {};", e1, e2),
            Stmt::Borrow(e1, e2) => writeln!(f, "{} borrow {};", e1, e2),
            Stmt::Expression(e) => writeln!(f, "{}", e),
            Stmt::Branch(blocks) => {
                writeln!(f, "@{}", blocks)
            }
            Stmt::Loop(block) => writeln!(f, "!{{\n{}\n}}", block),
            Stmt::Deallocate(exp) => writeln!(f, "deallocate {};", exp),
            Stmt::Comment(comment) => writeln!(f, "// {}", comment),
        }
    }
}

impl fmt::Display for Type {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Type::Own(props) => write!(f, "#own({})", props),
            Type::VoidTy => write!(f, "#voidTy"),
            Type::Ref(lft, box r#type) => write!(f, "#ref('{},{})", lft, r#type),
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
        let props_str = self
            .iter()
            .map(|prop| format!("{}", prop))
            .collect::<Vec<String>>()
            .join(",");
        write!(f, "{}", props_str)
    }
}

impl fmt::Display for Exps {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        let exps_str = self
            .iter()
            .map(|exp| format!("{}", exp))
            .collect::<Vec<String>>()
            .join(",");
        write!(f, "{}", exps_str)
    }
}

impl fmt::Display for Exp {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            Exp::NewRessource(props) => write!(f, "newResource({})", props),
            Exp::Id(id) => write!(f, "{}", id),
            Exp::Call(callee, exps) => write!(f, "call {}({});", callee, exps),
            Exp::Deref(exp) => write!(f, "*{}", exp),
        }
    }
}
