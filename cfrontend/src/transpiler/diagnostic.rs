use codespan_reporting::diagnostic::{Diagnostic, Label};
use codespan_reporting::files::SimpleFile;
use codespan_reporting::term;
use codespan_reporting::term::termcolor::{ColorChoice, StandardStream};

use lang_c::span::Span;

#[derive(Debug)]
pub struct CodespanReporter {
    file: SimpleFile<String, String>,
}

impl CodespanReporter {
    pub fn new(name: String, source: String) -> Self {
        Self {
            file: SimpleFile::new(name, source),
        }
    }

    pub fn unimplemented(&self, span: Span) {
        let diagnostic = Diagnostic::error()
            .with_message("Unimplemented C expression")
            .with_code("E001")
            .with_labels(vec![Label::primary((), span.start..span.end)]);

        let writer = StandardStream::stderr(ColorChoice::Always);
        let config = codespan_reporting::term::Config::default();

        term::emit(&mut writer.lock(), &config, &self.file, &diagnostic).unwrap();
        // impossible to control the io::Write with term::emit
        std::process::exit(1);
    }
}
