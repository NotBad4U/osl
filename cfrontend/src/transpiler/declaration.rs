use super::*;

impl Transpiler {
    pub(super) fn transpile_declaration(&mut self, declaration: &Declaration) -> Stmts {
        match (
            declaration.specifiers.as_slice(),
            declaration.declarators.as_slice(),
        ) {
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
            (
                [Node {
                    node:
                        DeclarationSpecifier::TypeSpecifier(Node {
                            node: TypeSpecifier::Struct(_),
                            ..
                        }),
                    ..
                }, ..],
                _,
            ) => Stmts::new(),
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

        // get the list of identifiers
        // T a = x, b = x => [a, b]
        let ids: Vec<String> = declaration
            .declarators
            .iter()
            .map(
                |Node {
                     node: InitDeclarator { declarator, .. },
                     ..
                 }| get_declarator_id(&declarator.node).unwrap(),
            )
            .collect();

        // store the new variables in the context map
        ids.iter().for_each(|id| {
            self.context
                .insert_in_last_scope(id, MutabilityContextItem::Variable(decl_mut.clone()))
        });

        Stmts(
            ids.into_iter()
                .map(|id| Stmt::Declaration(id, None))
                .collect(),
        )
    }
}
