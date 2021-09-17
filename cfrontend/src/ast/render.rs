use super::*;

type Program = Stmts;

const INDENTATION_SIZE: usize = 4;

pub fn render_program(program: Program) -> String {
    let indent = 0;
    program
        .0
        .iter()
        .map(|stmt| render_stmt(stmt, indent))
        .fold(String::new(), |mut acc, stmt| {
            acc.push_str(stmt.as_str());
            acc
        })
}

fn render_stmt(stmt: &Stmt, level: usize) -> String {
    let mut buff = String::new();

    match stmt {
        Stmt::Function(id, params, return_type, stmts) => {
            buff.push_str(&format!("fn {}({}) -> {} {{\n", id, params, return_type));

            stmts
                .iter()
                .map(|stmt| render_stmt(stmt, level + INDENTATION_SIZE))
                .for_each(|stmt_str| buff.push_str(&format!("{}", stmt_str)));
            buff.push_str(&format!("}};\n\n"));
        }
        Stmt::Branch(blocks) => {
            buff.push_str(&format!("{:indent$}@\n", "", indent = level));
            let blocks_s = blocks
                .0
                .iter()
                .map(|stmts| render_stmts(&stmts, level + INDENTATION_SIZE))
                .fold(Vec::new(), |mut acc, s| {
                    let mut block = String::new();
                    block.push_str(&format!("{:indent$}{{\n", "", indent = level));
                    block.push_str(&s);
                    block.push_str(&format!("{:indent$}}}", "", indent = level));
                    acc.push(block);
                    acc
                })
                .join(",\n");

            buff.push_str(&format!("{};\n", &blocks_s))
        }
        Stmt::Loop(block) => {
            buff.push_str(&format!("{:indent$}!{{\n", "", indent = level));
            buff.push_str(&render_stmts(block, level + INDENTATION_SIZE));
            buff.push_str(&format!("{:indent$}}};\n", "", indent = level));
        }
        Stmt::Unsafe(block) => {
            buff.push_str(&format!("{:indent$}unsafe{{\n", "", indent = level));
            buff.push_str(&render_stmts(block, level + INDENTATION_SIZE));
            buff.push_str(&format!("{:indent$}}};\n", "", indent = level));
        }
        e => buff.push_str(&format!("{:indent$}{}\n", "", e, indent = level)),
    }

    buff
}

fn render_stmts(stmts: &Stmts, level: usize) -> String {
    stmts.iter().fold(String::new(), |mut acc, stmt| {
        acc.push_str(&format!("{}", render_stmt(stmt, level)));
        acc
    })
}

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
            Stmt::Declaration(id) => write!(f, "decl {};", id),
            Stmt::Function(id, params, return_type, stmts) => {
                writeln!(f, "fn {}({}) -> {} {{", id, params, return_type).unwrap();
                write!(f, "{}", stmts).unwrap();
                writeln!(f, "}};\n")
            }
            Stmt::Val(exp) => write!(f, "val({})", exp),
            Stmt::Transfer(e1, e2) => write!(f, "transfer {} {};", e1, e2),
            Stmt::MBorrow(e1, e2) => write!(f, "{} mborrow {};", e1, e2),
            Stmt::Borrow(e1, e2) => write!(f, "{} borrow {};", e1, e2),
            Stmt::Expression(e) => write!(f, "{};", e),
            Stmt::Branch(blocks) => {
                write!(f, "@{}", blocks)
            }
            Stmt::Loop(block) => write!(f, "!{{\n{}\n}};", block),
            Stmt::Deallocate(exp) => write!(f, "deallocate {};", exp),
            Stmt::Comment(comment) => write!(f, "// {}", comment),
            Stmt::Unsafe(block) => write!(f, "unsafe{{\n{}\n}};", block),
            Stmt::Return(e) => write!(f, "val({})", e), // like expression but without semicolon
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
        let mut props_vec = self
            .iter()
            .map(|prop| format!("{}", prop))
            .collect::<Vec<String>>();
        props_vec.sort();
        write!(f, "{}", props_vec.join(","))
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
            Exp::NewResource(props) => write!(f, "newResource({})", props),
            Exp::Id(id) => write!(f, "{}", id),
            Exp::Call(callee, exps) => write!(f, "call {}({})", callee, exps),
            Exp::Deref(exp) => write!(f, "*{}", exp),
            Exp::Read(exp) => write!(f, "read({})", exp),
            Exp::Write(box exp1, box exp2) => write!(f, "{}", Stmt::Transfer(exp1.clone(), exp2.clone()))
        }
    }
}
