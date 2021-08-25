use super::*;

impl Transpiler {
    pub(super) fn transpile_declaration(&mut self, declaration: &Declaration) -> Stmts {
        match (
            declaration.specifiers.as_slice(),
            declaration.declarators.as_slice(),
        ) {
            // Array declaration
            (
                specifiers,
                [Node {
                    node:
                        InitDeclarator {
                            declarator:
                                Node {
                                    node:
                                        Declarator {
                                            kind:
                                                Node {
                                                    node:
                                                        DeclaratorKind::Identifier(Node {
                                                            node: Identifier { name },
                                                            ..
                                                        }),
                                                    ..
                                                },
                                            derived,
                                            ..
                                        },
                                    ..
                                },
                            initializer,
                        },
                    ..
                }],
            ) if matches!(
                derived.as_slice(),
                [Node {
                    node: DerivedDeclarator::Array(_),
                    ..
                }]
            ) =>
            {
                self.transpile_array_declaration(specifiers, name, initializer.is_some())
            }
            // typedef declaration
            (
                [Node {
                    node:
                        DeclarationSpecifier::StorageClass(Node {
                            node: StorageClassSpecifier::Typedef,
                            ..
                        }),
                    ..
                }, ..],
                _,
            ) => self.transpile_typedef_declaration(declaration),
            // header function declaration
            (
                _,
                [Node {
                    node:
                        InitDeclarator {
                            declarator,
                            initializer: None,
                        },
                    ..
                }, ..],
            ) if is_a_function(&declarator.node) => Stmts::new(),
            // Structure definition
            (
                // const struct T
                [Node {
                    node:
                        DeclarationSpecifier::TypeQualifier(Node {
                            node: TypeQualifier::Const,
                            ..
                        }),
                    ..
                }, Node {
                    node:
                        DeclarationSpecifier::TypeSpecifier(Node {
                            node: TypeSpecifier::Struct(Node{ node: structure, .. }),
                            ..
                        }),
                    ..
                }, ..]
                // struct T
                | [Node {
                    node:
                        DeclarationSpecifier::TypeSpecifier(Node {
                            node: TypeSpecifier::Struct(Node{ node: structure, .. }),
                            ..
                        }),
                    ..
                }, ..],
                declarations,
            ) => self.transpile_struct_declaration(structure, declarations),
            (
                [Node {
                    node:
                        DeclarationSpecifier::TypeSpecifier(Node {
                            node: TypeSpecifier::Enum(_),
                            ..
                        }),
                    ..
                }, ..],
                _,
            ) => Stmts::new(),
            _ => self.transpile_variables_declaration(&declaration),
        }
    }

    pub(super) fn transpile_struct_declaration(
        &mut self,
        structure: &StructType,
        declarations: &[Node<InitDeclarator>],
    ) -> Stmts {
        let structure_tag = structure.identifier.clone().unwrap().node.name;
        //TODO: get props from StructType
        self.context.types.insert(structure_tag, Props::new());

        declarations
            .iter()
            .map(|n| &n.node)
            .fold(Stmts::new(), |mut acc, init| {
                let id = utils::get_declarator_id(&init.declarator.node).expect("missing id");
                acc.0.push(Stmt::Declaration(id.to_string()));

                //TODO: get props from context
                self.context.insert_in_last_scope(
                    id.to_string(),
                    MutabilityContextItem::Variable(Mutability::MutOwner, Props::new()),
                );

                if init.initializer.is_some() {
                    acc.0.push(Stmt::Transfer(
                        Exp::NewResource(Props::new()),
                        Exp::Id(id.to_string()),
                    ));
                }

                acc
            })
    }

    /// Transpile array declaration
    /// TODO: Support the declaration of multiple array of the same type:
    /// int a,b[]
    pub(super) fn transpile_array_declaration(
        &mut self,
        specifiers: &[Node<DeclarationSpecifier>],
        name: &str,
        is_init: bool,
    ) -> Stmts {
        let mut stmts = Stmts::new();

        // I return a props just because I am lazy to pattern below
        let (mut_context, props) = if utils::is_const(specifiers) {
            (
                MutabilityContextItem::Variable(Mutability::ImmOwner, Props::new()),
                Props::new(),
            )
        } else {
            (
                MutabilityContextItem::Variable(Mutability::MutOwner, Props::from(Prop::Mut)),
                Props::from(Prop::Mut),
            )
        };

        self.context.insert_in_last_scope(name, mut_context);

        stmts.0.push(Stmt::Declaration(name.to_string()));

        if is_init {
            stmts.0.push(Stmt::Transfer(
                Exp::NewResource(props),
                Exp::Id(name.to_string()),
            ))
        }

        stmts
    }

    pub(super) fn transpile_typedef_declaration(&mut self, declaration: &Declaration) -> Stmts {
        let type_specifiers: Vec<TypeSpecifier> = declaration
            .specifiers
            .iter()
            .skip(1)
            .map(|specifier| extract!(DeclarationSpecifier::TypeSpecifier(_), &specifier.node))
            .filter(|x| x.is_some())
            .map(|x| x.unwrap().node.clone())
            .collect();

        let id = utils::get_declarator_id(&declaration.declarators[0].node.declarator.node)
            .expect(&format!("Can't find Id in Typedef => {:#?}", declaration));

        self.typedefs.insert(id, type_specifiers);

        Stmts::new()
    }

    /// This function return a Stmts because it is possible to declare multiple variables with same type in one line
    pub(super) fn transpile_variables_declaration(&mut self, declaration: &Declaration) -> Stmts {
        let decl_mut = get_mutability_of_declaration(declaration);

        // construct the props by looking at the types
        let props = get_props_from_declaration(declaration);

        // get the list of identifiers and the initializer expression
        let declarations: Vec<(String, &Option<Node<Initializer>>)> = declaration
            .declarators
            .iter()
            .map(
                |Node {
                     node:
                         InitDeclarator {
                             declarator,
                             initializer,
                         },
                     ..
                 }| (get_declarator_id(&declarator.node).unwrap(), initializer),
            )
            .collect();

        // store the new variables in the context map
        declarations.iter().for_each(|(id, _)| {
            self.context.insert_in_last_scope(
                id,
                MutabilityContextItem::Variable(decl_mut.clone(), props.clone()),
            )
        });

        declarations.into_iter().fold(
            Stmts::new(),
            |mut stmts, (id, initializer)| match initializer {
                Some(_) => {
                    stmts.0.push(Stmt::Declaration(id.clone()));

                    if let Some(Node { node, .. }) = initializer {
                        stmts.0.extend(self.transpile_initializer(id, &node).0);
                    }

                    stmts
                }
                None => {
                    stmts.0.push(Stmt::Declaration(id));
                    stmts
                }
            },
        )
    }

    /// This function transpile initializer in declaration of variable
    /// T a = <expression>
    /// TODO: For now this function is a little raw, maybe we can put some code in common with
    /// with other transpilation expressions functions
    fn transpile_initializer(&self, declarator: String, initializer: &Initializer) -> Stmts {
        let mutability = self
            .context
            .get_variable_mutability(declarator.as_str())
            .unwrap();

        match initializer {
            Initializer::Expression(ref expression) => match expression.node {
                Expression::UnaryOperator(box Node {
                    node:
                        UnaryOperatorExpression {
                            operator:
                                Node {
                                    node: UnaryOperator::Address,
                                    ..
                                },
                            operand:
                                box Node {
                                    node:
                                        Expression::Identifier(box Node {
                                            node: ref right_id, ..
                                        }),
                                    ..
                                },
                        },
                    ..
                }) => {
                    match mutability {
                        Mutability::ImmRef => Stmts::from(Stmt::Borrow(
                            Exp::Id(declarator),
                            Exp::Id(right_id.name.clone()),
                        )),
                        Mutability::MutRef => Stmts::from(Stmt::MBorrow(
                            Exp::Id(declarator),
                            Exp::Id(right_id.name.clone()),
                        )),
                        _ => unreachable!("The expression contain an Unary operator address"), // If we reach this code then it should be a problem in Context or storing context
                    }
                }
                Expression::Identifier(box Node { node: ref id, .. }) => Stmts::from(
                    Stmt::Transfer(Exp::Id(declarator), Exp::Id(id.name.clone())),
                ),
                Expression::Constant(ref constant) => {
                    let mut props = Props::new();

                    if let Mutability::MutOwner = mutability {
                        props.0.push(Prop::Mut);
                    }

                    if let Constant::Float(_) | Constant::Integer(_) = constant.node {
                        props.0.push(Prop::Copy);
                    }

                    Stmts::from(Stmt::Transfer(Exp::NewResource(props), Exp::Id(declarator)))
                }
                ref e => unimplemented!(
                    "{}",
                    self.reporter
                        .unimplemented(expression.span, &format!("{:?}", e))
                ),
            },
            Initializer::List(list) => unimplemented!(
                "{}",
                self.reporter.unimplemented(list.first().unwrap().span, "")
            ),
        }
    }
}
