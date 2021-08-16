use enum_extract::extract;
use lang_c::ast::*;
use lang_c::span;
use lang_c::span::Node;

use std::collections::HashMap;

use crate::ast::*;
use crate::configuration::Configuration;
use context::*;
use stdfun::StdlibFunction;
use utils::*;

mod branch;
mod context;
mod declaration;
mod diagnostic;
mod expression;
mod loops;
mod stdfun;
mod utils;

#[derive(Debug)]
pub struct Transpiler {
    pub stmts: Vec<crate::ast::Stmt>,
    context: MutabilityContext,
    typedefs: HashMap<String, Vec<TypeSpecifier>>,
    reporter: diagnostic::CodespanReporter,
    stdfun: StdlibFunction,
    config: Configuration,
}

impl Transpiler {
    pub fn new(source: String, config: Configuration) -> Self {
        Self {
            stmts: Vec::new(),
            context: MutabilityContext::new(),
            typedefs: HashMap::new(),
            reporter: diagnostic::CodespanReporter::new(source),
            stdfun: StdlibFunction::new(),
            config,
        }
    }

    /// Entry point of the transpilation of a C Program.
    pub fn transpile_translation_unit<'ast>(&mut self, translation_unit: &'ast TranslationUnit) {
        if self.config.intrinsic {
            // Add the Intrinsics function at the top of the transpiled files.
            // If you want to now the list of std functions supported, you can
            // find them in the module: stdfun.
            let std_funcs: Vec<Stmt> = self
                .stdfun
                .get_std_functions()
                .iter()
                .map(|func| (*func).clone())
                .collect();
            std_funcs.into_iter().for_each(|func| self.stmts.push(func));
        }

        for element in &translation_unit.0 {
            self.transpile_external_declaration(&element.node, &element.span);
        }

        // Append the call to C main function. OSL, as Python, doesn't need an entrypoint like the C main function.
        // We simulate the main function by adding this call at the bottom of the transpiled file.
        // This method work because in C there exist only functions and variables declarations at the top level.
        self.stmts.push(Stmt::Expression(Exp::Call(
            "main".to_string(),
            Exps(vec![]),
        )));
    }

    pub(super) fn transpile_function_def<'ast>(&mut self, function_def: &'ast FunctionDefinition) {
        self.context.create_new_scope();

        // Extract ownership information from the function definition
        let fn_id = get_declarator_id(&function_def.declarator.node).unwrap();
        let mut_return_type = get_return_fun_mutability_from_fun_def(function_def);

        // Inductive recursion on the compound statements
        let block_stmts = self.transpile_statement(&function_def.statement.node);

        let parameters = self.transpile_parameters_declaration(
            &get_function_parameters_from_declarator(&function_def.declarator.node),
        );

        let return_type =
            self.transpile_return_type_function_declaration(&parameters, &mut_return_type);

        self.context.insert_in_last_scope(
            fn_id.clone(),
            MutabilityContextItem::Function(return_type.clone()),
        );

        // Create the AST OSL corresponding node
        self.stmts
            .push(Stmt::Function(fn_id, parameters, return_type, block_stmts));

        self.context.pop_last_scope();
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
        _span: &span::Span,
    ) {
        match *external_declaration {
            ExternalDeclaration::FunctionDefinition(ref f) => {
                self.transpile_function_def(&f.node);
            }
            ExternalDeclaration::Declaration(ref d) => {
                let stmts = self.transpile_declaration(&d.node);
                self.stmts.extend(stmts.0);
            }
            ExternalDeclaration::StaticAssert(_) => {
                unimplemented!()
            }
        }
    }

    pub(super) fn transpile_parameters_declaration(
        &self,
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
                let param = match self.get_function_parameter_mutability(param) {
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

                acc.0.push(param);
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

    pub fn transpile_statement(&mut self, statement: &Statement) -> Stmts {
        match *statement {
            Statement::Expression(Some(ref e)) => Stmts::from(self.transpile_expression(&e.node)),
            Statement::Return(Some(ref r)) => self.transpile_return_statement(&r.node),
            Statement::Compound(ref block_items) => self.transpile_block_items(block_items),
            Statement::If(Node {
                node: ref if_stmt, ..
            }) => self.transpile_branchs(if_stmt),
            Statement::While(ref while_stmt) => self.transpile_while_statement(&while_stmt.node),
            Statement::For(ref forloop) => self.transpile_forloop_statement(&forloop.node),
            Statement::DoWhile(ref dowhile) => self.transpile_dowhile_statement(&dowhile.node),
            _ => unimplemented!(),
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
            Mutability::ImmRef => {
                Stmt::Borrow(Exp::Id(lhs.name.clone()), Exp::Id(rhs.name.clone()))
            }
            Mutability::MutRef => {
                Stmt::MBorrow(Exp::Id(lhs.name.clone()), Exp::Id(rhs.name.clone()))
            }
            _ => panic!("This should be a reference"),
        }
    }

    /// Transpile a list of statement in a block
    pub(super) fn transpile_block_items(&mut self, block_items: &Vec<Node<BlockItem>>) -> Stmts {
        let stmts = block_items
            .iter()
            .fold(Vec::<Stmt>::new(), |mut acc, item| {
                acc.append(&mut match item.node {
                    BlockItem::Statement(Node { node: ref stmt, .. }) => {
                        self.transpile_statement(stmt).0
                    }
                    BlockItem::Declaration(ref declaration) => {
                        self.transpile_declaration(&declaration.node).0
                    }
                    _ => unimplemented!(),
                });
                acc
            });

        Stmts(stmts)
    }

    fn transpile_return_statement(&mut self, exp: &Expression) -> Stmts {
        self.transpile_expression(exp)
    }
}
