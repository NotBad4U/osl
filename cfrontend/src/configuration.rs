#[derive(Debug, Clone)]
pub struct Configuration {
    /// Intrinsic functions are common C functions: printf, scanf, etc.
    /// that be found in stdlib and stdio library.
    pub intrinsic: bool,
}

impl Configuration {
    pub fn new(intrinsic: bool) -> Self {
        Self { intrinsic }
    }
}
