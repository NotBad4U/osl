use lang_c::span::Span;

pub type Result<T, E = TranspilationError> = std::result::Result<T, E>;

#[derive(Debug, Clone)]
pub enum TranspilationError {
    Unsupported(Span, String),
    Unimplemented(Span),
    Unknown(Span),
    Compound(Vec<TranspilationError>),
    Message(String),
    MessageSpan(Span, String),
    NotTranspilable(Span, String),
}

#[macro_export]
macro_rules! error_msg {
    ($exp:expr) => {
        Err(TranspilationError::Message($exp))
    };
}
