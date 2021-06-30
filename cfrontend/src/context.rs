use std::collections::HashMap;

type Context<'a> = Node<'a>;

#[derive(Debug)]
pub enum Mutability {
    ImmOwn,
    MutOwn,
    ImmRef,
    MutRef,
}

struct Node<'a> {
    parent: Option<&'a Node<'a>>,
    context: HashMap<String, Mutability>,
    childrens: Vec<Node<'a>>,
}


impl <'a> Node<'a> {
    fn new(parent: Option<&'a Node<'a>>) -> Self {
        Self{
            parent,
            context: HashMap::new(),
            childrens: Vec::new(),
        }
    }

    fn find_ascending(&self, ) {}
}
