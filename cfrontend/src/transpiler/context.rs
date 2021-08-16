use std::collections::HashMap;

use crate::ast::{Prop, Props, Type};

#[derive(Debug, Clone, PartialEq)]
pub enum Mutability {
    ImmOwner,
    MutOwner,
    MutRef,
    ImmRef,
}

#[derive(Debug, Clone)]
pub enum MutabilityContextItem {
    Function(Type),
    Variable(Mutability, Props),
}

#[derive(Debug)]
pub struct MutabilityContext {
    /// lexical scopes representation
    pub context: Vec<HashMap<String, MutabilityContextItem>>,
}

impl MutabilityContext {
    pub fn new() -> Self {
        Self {
            context: Vec::new(),
        }
    }

    /// The function do nothing if a block doesn't exist yet.
    pub fn insert_in_last_scope<S: Into<String>>(&mut self, id: S, item: MutabilityContextItem) {
        self.context
            .last_mut()
            .and_then(|ctx_map| ctx_map.insert(id.into(), item));
    }

    /// Create a new lexical scope
    pub fn create_new_scope(&mut self) {
        self.context.push(HashMap::new());
    }

    /// Pop the last lexical scope from the stack
    pub fn pop_last_scope(&mut self) {
        self.context.pop();
    }

    /// C work with lexical scope, so we only need to get the last
    /// function definition block context
    pub fn get_current_function_type(&self) -> Option<(String, Type)> {
        self.context
            .iter()
            .rev()
            .find_map(|scope| {
                scope
                    .iter()
                    .find(|(_, v)| matches!(v, MutabilityContextItem::Function(_)))
                    .and_then(|(k, v)| match v {
                        MutabilityContextItem::Function(mut_ret) => Some((k, mut_ret)),
                        _ => unreachable!(),
                    })
            })
            .map(|(k, v)| (k.clone(), v.clone()))
    }

    /// Try to get the mutability of an identifier declared insides blocks scopes
    pub fn get_variable_mutability(&self, id: &str) -> Option<Mutability> {
        self.context.iter().rev().find_map(|scope| {
            scope.get(id).and_then(|mut_var| match mut_var {
                MutabilityContextItem::Variable(vm, _) => Some(vm.clone()),
                _ => None,
            })
        })
    }

    pub fn get_props_of_variable(&self, var: &str) -> Option<Props> {
        self.context.iter().rev().find_map(|scope| {
            scope.get(var).and_then(|element| match element {
                MutabilityContextItem::Variable(_, props) => Some(props.clone()),
                _ => None,
            })
        })
    }
}

#[cfg(test)]
mod test_context {

    use super::*;

    #[test]
    fn it_should_get_first_function_mutability() {
        let mut ctx = MutabilityContext::new();

        ctx.create_new_scope();
        ctx.insert_in_last_scope(
            "fun1",
            MutabilityContextItem::Function(Type::Own(Props::new())),
        );

        ctx.create_new_scope();
        ctx.insert_in_last_scope(
            "fun2",
            MutabilityContextItem::Function(Type::Own(Props::new())),
        );
        ctx.insert_in_last_scope(
            "x",
            MutabilityContextItem::Variable(Mutability::MutOwner, Props::new()),
        );
        ctx.insert_in_last_scope(
            "y",
            MutabilityContextItem::Variable(Mutability::ImmOwner, Props::new()),
        );

        ctx.create_new_scope();
        ctx.insert_in_last_scope(
            "z",
            MutabilityContextItem::Variable(Mutability::ImmOwner, Props::new()),
        );

        let res = ctx.get_current_function_type();

        assert!(res.is_some());

        let (id, mut_ctx) = res.unwrap();

        assert_eq!(id, "fun2");
        assert_eq!(mut_ctx, Type::Own(Props::new()));
    }

    #[test]
    fn it_should_not_get_first_function_mutability_when_no_function_is_defined() {
        let mut ctx = MutabilityContext::new();

        ctx.create_new_scope();
        ctx.create_new_scope();

        let res = ctx.get_current_function_type();

        assert!(res.is_none());
    }

    #[test]
    fn it_should_get_variable_mutability() {
        let mut ctx = MutabilityContext::new();

        ctx.create_new_scope();
        ctx.insert_in_last_scope(
            "x",
            MutabilityContextItem::Variable(Mutability::MutOwner, Props::new()),
        );

        ctx.create_new_scope();
        ctx.insert_in_last_scope(
            "y",
            MutabilityContextItem::Variable(Mutability::ImmOwner, Props::new()),
        );

        ctx.create_new_scope();
        ctx.insert_in_last_scope(
            "z",
            MutabilityContextItem::Variable(Mutability::ImmOwner, Props::new()),
        );

        let res = ctx.get_variable_mutability("x");

        assert!(res.is_some());
        assert_eq!(res.unwrap(), Mutability::MutOwner);
    }

    #[test]
    fn it_should_not_get_variable_mutability_when_variable_is_not_defined() {
        let mut ctx = MutabilityContext::new();

        ctx.create_new_scope();
        ctx.insert_in_last_scope(
            "x",
            MutabilityContextItem::Variable(Mutability::MutOwner, Props::new()),
        );

        ctx.create_new_scope();
        ctx.insert_in_last_scope(
            "y",
            MutabilityContextItem::Variable(Mutability::ImmOwner, Props::new()),
        );

        ctx.create_new_scope();
        ctx.insert_in_last_scope(
            "z",
            MutabilityContextItem::Variable(Mutability::ImmOwner, Props::new()),
        );

        let res = ctx.get_variable_mutability("value_not_defined");

        assert!(res.is_none());
    }

    #[test]
    fn it_should_pop_the_last_scope() {
        let mut mut_ctx = MutabilityContext::new();

        mut_ctx.create_new_scope();
        mut_ctx.create_new_scope();

        mut_ctx.pop_last_scope();

        assert_eq!(1, mut_ctx.context.len());
    }
}
