use std::collections::{HashMap, HashSet};

use crate::ast::{Props, Type, Parameters};

#[derive(Debug, Clone, PartialEq)]
pub enum Mutability {
    ImmOwner,
    MutOwner,
    MutRef,
    ImmRef,
}

#[derive(Debug, Clone)]
pub struct Stats {
    number_of_times_modifed: usize,
}

impl Default for Stats {
    fn default() -> Self {
        Self {
            number_of_times_modifed: 0,
        }
    }
}

#[derive(Debug, Clone)]
pub enum MutabilityContextItem {
    Function(Type, Parameters),
    Variable(Mutability, Props, Stats),
}

impl MutabilityContextItem {
    pub fn variable(mutability: Mutability, props: Props) -> Self {
        Self::Variable(mutability, props, Stats::default())
    }
}

#[derive(Debug, Clone)]
pub enum Ctype {
    /// contains the intersection of all props
    /// between all the fields
    Struct(Props),
    /// contains all the variant
    Enum(HashSet<String>),
}

#[derive(Debug)]
pub struct MutabilityContext {
    /// lexical scopes representation
    pub context: Vec<HashMap<String, MutabilityContextItem>>,
    pub types: HashMap<String, Ctype>,
}

impl MutabilityContext {
    pub fn new() -> Self {
        Self {
            context: Vec::new(),
            types: HashMap::new(),
        }
    }

    pub fn is_constant_in_enum(&self, id: &str) -> bool {
        self.types
            .iter()
            .find_map(|r#type| match r#type.1 {
                Ctype::Enum(set) => set.get(id),
                _ => None,
            })
            .is_some()
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
                    .find(|(_, v)| matches!(v, MutabilityContextItem::Function(_, _)))
                    .and_then(|(k, v)| match v {
                        MutabilityContextItem::Function(mut_ret, ..) => Some((k, mut_ret)),
                        _ => unreachable!(),
                    })
            })
            .map(|(k, v)| (k.clone(), v.clone()))
    }

    /// Try to get the mutability of an identifier declared insides blocks scopes
    pub fn get_variable_mutability(&self, id: &str) -> Option<Mutability> {
        self.context.iter().rev().find_map(|scope| {
            scope.get(id).and_then(|mut_var| match mut_var {
                MutabilityContextItem::Variable(vm, _, _) => Some(vm.clone()),
                _ => None,
            })
        })
    }

    pub fn get_props_of_variable(&self, var: &str) -> Option<Props> {
        self.context.iter().rev().find_map(|scope| {
            scope.get(var).and_then(|element| match element {
                MutabilityContextItem::Variable(_, props, _) => Some(props.clone()),
                _ => None,
            })
        })
    }

    pub fn get_function(&self, function_name: &str) -> Option<&MutabilityContextItem> {
        self.context.iter().rev().find_map(|scope| {
                scope.get(function_name)
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
            MutabilityContextItem::Function(Type::Own(Props::new()), Parameters::new()),
        );

        ctx.create_new_scope();
        ctx.insert_in_last_scope(
            "fun2",
            MutabilityContextItem::Function(Type::Own(Props::new()), Parameters::new()),
        );
        ctx.insert_in_last_scope(
            "x",
            MutabilityContextItem::variable(Mutability::MutOwner, Props::new()),
        );
        ctx.insert_in_last_scope(
            "y",
            MutabilityContextItem::variable(Mutability::ImmOwner, Props::new()),
        );

        ctx.create_new_scope();
        ctx.insert_in_last_scope(
            "z",
            MutabilityContextItem::variable(Mutability::ImmOwner, Props::new()),
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
            MutabilityContextItem::variable(Mutability::MutOwner, Props::new()),
        );

        ctx.create_new_scope();
        ctx.insert_in_last_scope(
            "y",
            MutabilityContextItem::variable(Mutability::ImmOwner, Props::new()),
        );

        ctx.create_new_scope();
        ctx.insert_in_last_scope(
            "z",
            MutabilityContextItem::variable(Mutability::ImmOwner, Props::new()),
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
            MutabilityContextItem::variable(Mutability::MutOwner, Props::new()),
        );

        ctx.create_new_scope();
        ctx.insert_in_last_scope(
            "y",
            MutabilityContextItem::variable(Mutability::ImmOwner, Props::new()),
        );

        ctx.create_new_scope();
        ctx.insert_in_last_scope(
            "z",
            MutabilityContextItem::variable(Mutability::ImmOwner, Props::new()),
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
