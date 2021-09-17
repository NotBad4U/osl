#![feature(box_patterns)]
#![feature(box_syntax)]

#[macro_use]
extern crate log;

use annotate_snippets::{
    display_list::{DisplayList, FormatOptions},
    snippet::{AnnotationType, Slice, Snippet, SourceAnnotation},
};
use lang_c::span::Span;
use cfrontend::configuration::Configuration;
use cfrontend::transpiler::errors::TranspilationError;
use env_logger::Builder;
use lang_c::driver::Config;
use log::LevelFilter;

const TEST_C_FILE: &str = "test.c";

fn main() {
    let mut builder = Builder::from_default_env();
    builder.filter(None, LevelFilter::Info).init();

    info!("parsing {}...", TEST_C_FILE);

    match lang_c::driver::parse(&Config::default(), TEST_C_FILE) {
        Ok(ast) => {
            info!("transpiling {}...", TEST_C_FILE);
            match cfrontend::transpile_c_program(ast.clone(), Configuration::new(true)) {
                Ok(stmts) => println!("{}", cfrontend::ast::render::render_program(stmts)),
                Err(errors) => print_errors(ast.source.as_str(), errors),
            }
        }
        Err(e) => eprintln!("Error C parsing source code: {}", e),
    }
}

fn print_errors(source: &str, errors: Vec<TranspilationError>) {
    errors.into_iter().for_each(|e| match e {
        TranspilationError::Unimplemented(span) => unimplemented(source, span),
        TranspilationError::Unsupported(span, reason) => unsupported(source, span, reason),
        TranspilationError::Unknown(span) => unimplemented(source, span),
        TranspilationError::Compound(errors) => print_errors(source, errors),
        TranspilationError::Message(msg) => eprint!("{}", msg),
        TranspilationError::NotTranspilable(span, reason) => unsupported(source, span, reason.as_str()),
    })
}

fn unimplemented(source: &str, span: Span) {
    let snippet = Snippet {
        title: None,
        footer: vec![],
        slices: vec![Slice {
            source: source,
            line_start: 0,
            origin: None,
            fold: true,
            annotations: vec![SourceAnnotation {
                label: "todo one day...",
                annotation_type: AnnotationType::Error,
                range: (span.start, span.end),
            }],
        }],
        opt: FormatOptions {
            color: true,
            ..Default::default()
        },
    };
    eprint!("{}", DisplayList::from(snippet))
}

fn unsupported(source: &str, span: Span, reason: &str) {
    let snippet = Snippet {
        title: None,
        footer: vec![],
        slices: vec![Slice {
            source: source,
            line_start: 0,
            origin: None,
            fold: true,
            annotations: vec![SourceAnnotation {
                label: reason,
                annotation_type: AnnotationType::Warning,
                range: (span.start, span.end),
            }],
        }],
        opt: FormatOptions {
            color: true,
            ..Default::default()
        },
    };
    eprint!("{}", DisplayList::from(snippet))
}

fn unknown(source: &str, span: Span) {
    let snippet = Snippet {
        title: None,
        footer: vec![],
        slices: vec![Slice {
            source: source,
            line_start: 0,
            origin: None,
            fold: true,
            annotations: vec![SourceAnnotation {
                label: "",
                annotation_type: AnnotationType::Warning,
                range: (span.start, span.end),
            }],
        }],
        opt: FormatOptions {
            color: true,
            ..Default::default()
        },
    };
    eprint!("{}", DisplayList::from(snippet))
}
