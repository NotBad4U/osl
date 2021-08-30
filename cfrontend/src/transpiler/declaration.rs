use super::*;
use crate::node;

use std::collections::HashSet;
use std::iter::FromIterator;

impl Transpiler {
    pub(super) fn transpile_declaration(&mut self, declaration: &Declaration) -> Stmts {
        match (
            declaration.specifiers.as_slice(),
            declaration.declarators.as_slice(),
        ) {
            // Array declaration
            (
                specifiers,
                [node!(InitDeclarator {
                    declarator: node!(
                        Declarator {
                            kind: node!(DeclaratorKind::Identifier(node!(Identifier { name }))),
                            derived,
                            ..
                        }
                    ),
                    initializer,
                })],
            ) if matches!(
                derived.as_slice(),
                [node!(DerivedDeclarator::Array(_))]
            ) =>
            {
                self.transpile_array_declaration(specifiers, name, initializer.is_some())
            }
            // typedef declaration
            (
                [node!(DeclarationSpecifier::StorageClass(node!(StorageClassSpecifier::Typedef))), ..],
                _,
            ) => self.transpile_typedef_declaration(declaration),
            // header function declaration
            (
                _,
                [
                    node!(
                        InitDeclarator {
                            declarator,
                            initializer: None,
                        }
                    ),
                    ..
                ],
            ) if is_a_function(&declarator.node) => Stmts::new(),
            // Structure definition
            (
                // const struct T
                [
                    node!(
                        DeclarationSpecifier::TypeQualifier(node!(TypeQualifier::Const))
                    ),
                    node!(
                        DeclarationSpecifier::TypeSpecifier(
                            node!(TypeSpecifier::Struct(node!(structure))))),
                    ..
                ]
                // struct T
                | [
                    node!(
                        DeclarationSpecifier::TypeSpecifier(node!(TypeSpecifier::Struct(node!(structure))))
                    ),
                    ..
                ],
                declarations,
            ) => self.transpile_struct_declaration(structure, declarations),
            // Enum T { constant1, constant2, .. ,constantN }
            (
                [
                    node!(DeclarationSpecifier::TypeSpecifier(node!(TypeSpecifier::Enum(node!(enum_type))))),
                    ..
                ],
                [],
            ) => self.transpile_enum_type_definition(&enum_type),
            // enum Name Id;
            (
                [
                    node!(DeclarationSpecifier::TypeSpecifier(node!(TypeSpecifier::Enum(_)))),
                ],
                [
                    node!(InitDeclarator{ declarator: node!(Declarator{kind: node!(DeclaratorKind::Identifier(node!(Identifier{name}))), ..}) , ..})
                ],
            ) => self.transpile_enum_declaration(name),
            _ => self.transpile_variables_declaration(&declaration),
        }
    }

    pub(super) fn transpile_enum_declaration(&mut self, id: &str) -> Stmts {
        self.context.insert_in_last_scope(
            id,
            MutabilityContextItem::Variable(Mutability::MutOwner, Props::from(Prop::Copy)),
        );
        Stmts::from(Stmt::Declaration(id.to_string()))
    }

    pub(super) fn transpile_enum_type_definition(&mut self, enum_type: &EnumType) -> Stmts {
        let constants = enum_type.enumerators.iter().map(|n| &n.node).fold(
            HashSet::new(),
            |mut acc, enumerator| {
                acc.insert(enumerator.identifier.node.name.to_string());
                acc
            },
        );
        let id = enum_type
            .identifier
            .clone()
            .map(|n| n.node.name.to_string())
            .unwrap_or("global_enum".to_string());

        self.context.types.insert(id, Ctype::Enum(constants));
        Stmts::new()
    }

    pub(super) fn transpile_struct_declaration(
        &mut self,
        structure: &StructType,
        declarations: &[Node<InitDeclarator>],
    ) -> Stmts {
        let mut props = self.get_props_of_struct_from_fields(
            structure.declarations.as_ref().unwrap_or(&Vec::new()),
        );

        if let Some(tag) = structure.identifier.clone() {
            self.context
                .types
                .insert(tag.node.name, Ctype::Struct(props.clone()));
        }

        declarations
            .iter()
            .map(|n| &n.node)
            .fold(Stmts::new(), |mut acc, init| {
                let id = utils::get_declarator_id(&init.declarator.node).expect("missing id");
                acc.0.push(Stmt::Declaration(id.to_string()));

                //TODO: get props from context
                self.context.insert_in_last_scope(
                    id.to_string(),
                    MutabilityContextItem::Variable(Mutability::MutOwner, props.clone()),
                );

                println!("{:#?}", self.context.context);

                if init.initializer.is_some() {
                    acc.0.push(Stmt::Transfer(
                        Exp::NewResource(props.clone()),
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
                |node!(InitDeclarator {
                     declarator,
                     initializer,
                 })| (get_declarator_id(&declarator.node).unwrap(), initializer),
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

                    if let Some(node!(node)) = initializer {
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
                Expression::UnaryOperator(
                    box node!(UnaryOperatorExpression {
                        operator: node!(UnaryOperator::Address),
                        operand: box node!(Expression::Identifier(box node!(ref right_id))),
                    }),
                ) => {
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
                Expression::Identifier(box node!(ref id)) => Stmts::from(Stmt::Transfer(
                    Exp::Id(declarator),
                    Exp::Id(id.name.clone()),
                )),
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

    fn get_props_of_struct_from_fields(&self, fields: &Vec<Node<StructDeclaration>>) -> Props {
        let fields: Vec<&StructField> = fields
            .iter()
            .map(|n| &n.node)
            .map(|field_dec| match field_dec {
                StructDeclaration::Field(node!(field)) => Some(field),
                _ => None,
            })
            .filter_map(|x| x)
            .collect();
        let mut props = Props(
            fields
                .iter()
                .map(|field| match field.specifiers.as_slice() {
                    [node!(SpecifierQualifier::TypeSpecifier(node!(
                        TypeSpecifier::Struct(node!(StructType {
                            identifier: Some(node!(Identifier { name })),
                            declarations: None,
                            ..
                        }))
                    ))), ..] => match self.context.types.get(name).cloned() {
                        Some(Ctype::Struct(props)) => props,
                        _ => unreachable!("The structure was not captured before"),
                    },
                    // declaration of a structure in this structure
                    [node!(SpecifierQualifier::TypeSpecifier(node!(
                        TypeSpecifier::Struct(node!(StructType {
                            declarations: Some(declarations),
                            ..
                        }))
                    ))), ..] => self.get_props_of_struct_from_fields(declarations),
                    // normal variable
                    _ => utils::get_props_from_specifiers_qualifier_and_declaration(
                        &field.specifiers,
                        &field.declarators,
                    ),
                })
                .map(|props| HashSet::from_iter(props.0))
                .fold(
                    HashSet::from_iter(Props::get_all_props().0),
                    |mut acc: HashSet<Prop>, props_set| {
                        let tmp = acc.intersection(&props_set).collect::<HashSet<_>>();
                        acc = tmp.into_iter().map(|x| x.clone()).collect();
                        acc
                    },
                )
                .into_iter()
                .collect(),
        );

        // Using Hashet make the display of props not deterministic.
        // This break the automatic tests base on string equivalence.
        // To make it deterministic, we sort the props.
        props.0.sort();
        props
    }
}
