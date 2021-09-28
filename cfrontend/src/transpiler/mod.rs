use enum_extract::extract;
use lang_c::ast::*;
use lang_c::span::Node;

use std::collections::HashMap;

use crate::ast::*;
use crate::configuration::Configuration;
use crate::error_msg;
use crate::transpiler::errors::Result;
use crate::transpiler::errors::TranspilationError;
use context::*;
use stdfun::StdlibFunction;
use utils::*;

pub mod errors;

mod branch;
mod context;
mod declaration;
mod expression;
mod loops;
mod stdfun;
#[macro_use]
mod utils;

#[derive(Debug)]
pub struct Transpiler {
    context: MutabilityContext,
    typedefs: HashMap<String, Vec<TypeSpecifier>>,
    stdfun: StdlibFunction,
    config: Configuration,
}

#[derive(Debug, Clone)]
pub enum Effect {
    /// Represent a statement: transfer e1 e2
    Write(Exp, Exp),
    /// Read the value of a variable
    Read(Exp),
    Deref(Exp),
    Call(Exp),
    /// Create a new ressource
    Constant(Exp),
    // look at a variable
    Lookup(String),
}

impl Into<Stmt> for Effect {
    fn into(self) -> Stmt {
        match self {
            Self::Write(e1, e2) => Stmt::Transfer(e1, e2),
            Self::Read(e) if matches!(e, Exp::Read(_)) => Stmt::Expression(e),
            Self::Read(e) => Stmt::Expression(Exp::Read(box e)),
            Self::Deref(e) if matches!(e, Exp::Deref(_)) => Stmt::Expression(e),
            Self::Deref(e) => Stmt::Expression(Exp::Deref(box e)),
            Self::Call(e) => Stmt::Expression(e),
            Self::Constant(e) => Stmt::Val(e),
            Self::Lookup(id) => Stmt::Expression(Exp::Id(id.into())),
        }
    }
}

impl Into<Exp> for Effect {
    fn into(self) -> Exp {
        match self {
            Self::Write(e1, e2) => Exp::Statement(box Stmt::Transfer(e1, e2)),
            Self::Read(e) if matches!(e, Exp::Read(_)) => e,
            Self::Read(e) => Exp::Read(box e),
            Self::Deref(e) if matches!(e, Exp::Deref(_)) => e,
            Self::Deref(e) => Exp::Deref(box e),
            Self::Call(e) => e,
            Self::Constant(e) => e,
            Self::Lookup(id) => Exp::Id(id.into()),
        }
    }
}

#[derive(Debug, Clone)]
pub struct EffectsExp {
    /// The effects relied to the below statement
    /// x = foo() + y;
    /// The effect will be: Call(foo), read(y)
    effects: Vec<Effect>,
    /// The transpile statement
    expression: Exp,
}

impl From<Exp> for EffectsExp {
    fn from(exp: Exp) -> Self {
        EffectsExp::new(None, exp)
    }
}

impl EffectsExp {
    fn new(effects: Option<Vec<Effect>>, expression: Exp) -> Self {
        Self {
            effects: effects.unwrap_or(Vec::default()),
            expression,
        }
    }

    fn fmap_stmts<F>(self, func: F) -> Stmts
    where
        F: Fn(Exp) -> Stmt,
    {
        let mut stmts = self.effects.into_iter().fold(Stmts::new(), |mut acc, eff| {
            acc.push(eff.into());
            acc
        });
        stmts.push(func(self.expression));
        stmts
    }
}

impl Into<Stmts> for EffectsExp {
    fn into(self) -> Stmts {
        let mut stmts = self.effects.into_iter().fold(Stmts::new(), |mut acc, eff| {
            acc.push(eff.into());
            acc
        });
        stmts.push(Stmt::Expression(self.expression));
        stmts
    }
}

use std::fmt::Debug;

impl Transpiler {
    pub fn new(config: Configuration) -> Self {
        Self {
            context: MutabilityContext::new(),
            typedefs: HashMap::new(),
            stdfun: StdlibFunction::new(),
            config,
        }
    }

    /// Entry point of the transpilation of a C Program.
    pub fn transpile_translation_unit<'ast>(
        &mut self,
        translation_unit: &'ast TranslationUnit,
    ) -> Result<Stmts, Vec<TranspilationError>> {
        // Scope for global variables
        self.context.create_new_scope();

        let std_funcs = if self.config.intrinsic {
            // Add the Intrinsics function at the top of the transpiled files.
            // If you want to now the list of std functions supported, you can
            // find them in the module: stdfun.
            self.stdfun
                .get_std_functions()
                .iter()
                .map(|func| (*func).clone())
                .fold(Stmts::new(), |mut acc, function| {
                    acc.push(function);
                    acc
                })
        } else {
            Stmts::new()
        };

        let (ast, errors) = translation_unit
            .0
            .iter()
            .fold(Vec::new(), |mut results, node!(external_declaration)| {
                results.push(self.transpile_external_declaration(&external_declaration));
                results
            })
            .into_iter()
            .fold((Stmts::new(), vec![]), |(mut ast, mut errors), result| {
                match result {
                    Ok(stmts) => ast.append(stmts),
                    Err(e) => errors.push(e),
                };

                (ast, errors)
            });

        if errors.is_empty() {
            let mut program = std_funcs;
            program.append(ast);
            // Append the call to C main function. OSL, as Python, doesn't need an entrypoint like the C main function.
            // We simulate the main function by adding this call at the bottom of the transpiled file.
            // This method work because in C there exist only functions and variables declarations at the top level.
            program.push(Stmt::Expression(Exp::Statement(box Stmt::Expression(
                Exp::Call("main".into(), Exps(vec![])),
            ))));

            Ok(program)
        } else {
            Err(errors)
        }
    }

    pub(super) fn transpile_function_def<'ast>(
        &mut self,
        function_def: &'ast FunctionDefinition,
    ) -> Result<Stmt> {
        self.context.create_new_scope();

        // Extract ownership information from the function definition
        let fn_id = get_declarator_id(&function_def.declarator.node).unwrap();
        let mut_return_type = get_return_fun_mutability_from_fun_def(function_def);

        let parameters = self.transpile_parameters_declaration(
            &get_function_parameters_from_declarator(&function_def.declarator.node),
        );

        // Inductive recursion on the compound statements
        let block_stmts = self.transpile_statement(&function_def.statement)?;

        let mut return_type =
            self.transpile_return_type_function_declaration(&parameters, &mut_return_type);

        match return_type {
            Type::Own(ref mut props) if utils::is_copy(&function_def) => {
                props.push(Prop::Copy);
            }
            _ => {}
        };

        self.context.insert_in_last_scope(
            fn_id.clone(),
            MutabilityContextItem::Function(return_type.clone()),
        );

        self.context.pop_last_scope();

        // Create the AST OSL corresponding node
        Ok(Stmt::Function(fn_id, parameters, return_type, block_stmts))
    }

    fn transpile_return_type_function_declaration(
        &mut self,
        params: &Parameters,
        mutability_function: &Option<Mutability>,
    ) -> Type {
        // if there is exactly one input lifetime parameter (in other words, the only parameter is a reference),
        // that lifetime is assigned to all output lifetime parameters:
        // e.g.: fn foo(x: ref('a, T)) -> ref('a, T).
        // The rule apply even if the parameter and return type are different.
        match (params.0.as_slice(), mutability_function) {
            // The only parameter and return type are references
            (_, None) => Type::VoidTy,
            (
                [Parameter(_, Type::Ref(lifetime, mutability))],
                Some(Mutability::ImmRef) | Some(Mutability::MutRef),
            ) => Type::Ref(lifetime.to_string(), box *mutability.clone()),
            (_, Some(Mutability::ImmOwner)) => Type::Own(Props(vec![])),
            (_, Some(Mutability::MutOwner)) => Type::Own(Props(vec![Prop::Mut])),
            (_, Some(Mutability::MutRef)) => {
                // To avoid conflict on lifetime lexical name, we use "rt" has the default name for return
                Type::Ref("rt".to_string(), box Type::Own(Props(vec![Prop::Mut])))
            }
            (_, Some(Mutability::ImmRef)) => {
                Type::Ref("rt".to_string(), box Type::Own(Props(vec![])))
            }
        }
    }

    pub(super) fn transpile_external_declaration(
        &mut self,
        external_declaration: &ExternalDeclaration,
    ) -> Result<Stmts, TranspilationError> {
        match external_declaration {
            ExternalDeclaration::FunctionDefinition(node!(fun_def)) => {
                self.transpile_function_def(fun_def).map(Stmts::from)
            }
            ExternalDeclaration::Declaration(node!(declaration)) => {
                self.transpile_declaration(&declaration)
            }
            ExternalDeclaration::StaticAssert(ref node) => Err(TranspilationError::Unsupported(
                node.span,
                "not relevant for ownership type".into(),
            )),
        }
    }

    pub(super) fn transpile_parameters_declaration(
        &mut self,
        params: &Vec<ParameterDeclaration>,
    ) -> Parameters {
        params
            .iter()
            .enumerate()
            .fold(Parameters(Vec::new()), |mut acc, (index, param)| {
                let id = get_declarator_id(&param.declarator.as_ref().unwrap().node).unwrap();

                //  Each parameter that is a reference gets its own lifetime parameter.
                // In other words, a function with one parameter gets one lifetime parameter: fn foo(x: ref('a, Type));
                // a function with two parameters gets two separate lifetime parameters: fn foo(x: ref('a, Type), y: ref('b, Type)); and so on.
                // This follow the rules of input lifetimes of Rust lang function.
                let mutability = self.get_function_parameter_mutability(param);

                let param = match mutability {
                    Mutability::MutOwner => Parameter(id, Type::Own(Props::from(Prop::Mut))),
                    Mutability::ImmOwner => Parameter(id, Type::Own(Props::new())),
                    Mutability::MutRef => Parameter(
                        id,
                        Type::Ref(
                            utils::generate_lifetime(index),
                            box Type::Own(Props::from(Prop::Mut)),
                        ),
                    ),
                    Mutability::ImmRef => Parameter(
                        id,
                        Type::Ref(utils::generate_lifetime(index), box Type::Own(Props::new())),
                    ),
                };

                self.context.insert_in_last_scope(
                    param.0.clone(),
                    MutabilityContextItem::variable(mutability, param.1.props()),
                );

                acc.push(param);
                acc
            })
    }

    pub(super) fn get_function_parameter_mutability(
        &self,
        param: &ParameterDeclaration,
    ) -> Mutability {
        let declarator = &param.declarator.as_ref().unwrap().node;

        if is_a_ref(declarator) {
            if is_const(param.specifiers.as_slice()) {
                Mutability::ImmRef
            } else {
                Mutability::MutRef
            }
        } else {
            if is_const(param.specifiers.as_slice()) {
                Mutability::ImmOwner
            } else {
                Mutability::MutOwner
            }
        }
    }

    /// Transpile statements of the program with a recursive approach.
    pub fn transpile_statement(&mut self, statement: &Node<Statement>) -> Result<Stmts> {
        match statement.node {
            Statement::Expression(Some(ref e)) => self
                .transpile_expression(&e.node)
                .map(|effstmt| effstmt.into()),
            Statement::Expression(None) => Ok(Stmts::new()),
            Statement::Return(Some(ref r)) => self.transpile_return_statement(&r.node),
            Statement::Return(None) => Ok(Stmts::new()),
            Statement::Compound(ref block_items) => self.transpile_block_items(block_items),
            Statement::If(node!(ref if_stmt)) => self.transpile_branchs(if_stmt),
            Statement::While(ref while_stmt) => self.transpile_while_statement(&while_stmt.node),
            Statement::For(ref forloop) => self.transpile_forloop_statement(&forloop.node),
            Statement::DoWhile(ref dowhile) => self.transpile_dowhile_statement(&dowhile.node),
            // Ignore assembly statements because it is not possible to evalutate them
            // for our ownership type semantic.
            Statement::Asm(_) => Ok(Stmts::new()),
            Statement::Switch(node!(ref switch_stmt)) => self.transpile_switch_case(switch_stmt),
            Statement::Goto(Node { span, .. }) => Err(TranspilationError::Unsupported(
                span,
                "OSL doesn't support unconditional jump".into(),
            )),
            Statement::Break | Statement::Continue => Err(TranspilationError::Unsupported(
                statement.span,
                "No semantic in K to support it".into(),
            )),
            Statement::Labeled(
                node!(LabeledStatement {
                    label: node!(Label::Identifier(node!(Identifier { ref name }))),
                    statement: box ref node
                }),
            ) if name.to_lowercase() == "unsafe" => self
                .transpile_statement(&node)
                .map(|statements| Stmts::from(Stmt::Unsafe(statements))),
            Statement::Labeled(Node { span, .. }) => Err(TranspilationError::Unsupported(
                span,
                "No semantic in K to support label".into(),
            )),
        }
    }

    pub(super) fn transpile_ref_assignment(&mut self, lhs: &Identifier, rhs: &Identifier) -> Stmt {
        let left_mut = self
            .context
            .get_variable_mutability(lhs.name.as_str())
            .unwrap_or_else(|| {
                panic!(
                    "The variable {} has not been catched by the transpiler during processing",
                    lhs.name.as_str()
                )
            });
        self.context
            .get_variable_mutability(rhs.name.as_str())
            .unwrap_or_else(|| {
                panic!(
                    "The variable {} has not been catched by the transpiler during processing",
                    rhs.name.as_str()
                )
            });

        match left_mut {
            Mutability::ImmRef => Stmt::Expression(Exp::Statement(box Stmt::Borrow(
                Exp::Id(lhs.name.clone()),
                Exp::Id(rhs.name.clone()),
            ))),
            Mutability::MutRef => Stmt::Expression(Exp::Statement(box Stmt::MBorrow(
                Exp::Id(lhs.name.clone()),
                Exp::Id(rhs.name.clone()),
            ))),
            _ => panic!("This should be a reference"),
        }
    }

    /// Transpile a list of statement in a block
    pub(super) fn transpile_block_items(
        &mut self,
        block_items: &Vec<Node<BlockItem>>,
    ) -> Result<Stmts, TranspilationError> {
        let (ast, errors) = block_items.iter().fold(
            (Stmts::new(), Vec::new()),
            |(mut statements, mut errors), item| {
                let res = match item.node {
                    BlockItem::Statement(ref stmt) => self.transpile_statement(&stmt),
                    BlockItem::Declaration(ref declaration) => {
                        self.transpile_declaration(&declaration.node)
                    }
                    BlockItem::StaticAssert(ref assert) => Err(TranspilationError::Unsupported(
                        assert.span,
                        "Not relevant for ownership type".into(),
                    )),
                };

                match res {
                    Ok(stmts) => statements.append(stmts),
                    Err(e) => errors.push(e),
                }

                (statements, errors)
            },
        );

        if errors.is_empty() {
            Ok(ast)
        } else {
            Err(TranspilationError::Compound(errors))
        }
    }

    fn transpile_return_statement(&mut self, exp: &Expression) -> Result<Stmts> {
        self.transpile_expression(exp).map(|effstmt| {
            //FIXME: manage effect
            Stmts::from(match effstmt.expression {
                Exp::Statement(box Stmt::Expression(e)) => Stmt::Return(e),
                expression => Stmt::Return(expression),
            })
        })
    }

    fn transpile_switch_case(&mut self, switch: &SwitchStatement) -> Result<Stmts> {
        let mut statements: Stmts = self.transpile_expression(&switch.expression.node)?.into();

        let blocks_transpiled = if let Statement::Compound(ref stmts) = switch.statement.node {
            stmts
                .iter()
                .map(|ref stmt| match &stmt.node {
                    BlockItem::Statement(
                        node!(Statement::Labeled(
                            node!(LabeledStatement { box statement, .. })
                        )),
                    ) => self.transpile_statement(&statement),
                    BlockItem::Statement(statement) => {
                        Err(TranspilationError::Unknown(statement.span))
                    }
                    BlockItem::Declaration(ref declaration) => {
                        Err(TranspilationError::Unknown(declaration.span))
                    }
                    BlockItem::StaticAssert(ref assert) => Err(TranspilationError::Unsupported(
                        assert.span,
                        "Not relevant for ownership type".into(),
                    )),
                })
                .filter(|res| matches!(res, Ok(stmts) if stmts.is_empty() == false)) // filter the Break and empty block
                .collect::<Result<Vec<_>, _>>()
        } else {
            error_msg!("The switch statement don't use a Compound statement structure".into())
        }?;
        statements.push(Stmt::Branch(Blocks(blocks_transpiled)));
        Ok(statements)
    }
}
