use annotate_snippets::{
    display_list::{DisplayList, FormatOptions},
    snippet::{AnnotationType, Slice, Snippet, SourceAnnotation},
};
use cfrontend::configuration::Configuration;
use cfrontend::transpiler::errors::TranspilationError;
use lang_c::driver::Config;
use lang_c::driver::Error as LangCError;
use lang_c::span::Span;
use regex::Regex;

use std::error::Error;
use std::fs::File;
use std::io::Write;
use std::path::Path;
use std::path::PathBuf;
use std::process::Command;

//TODO: Check in $PATH also
pub fn are_k_bins_installed() -> bool {
    return Path::new("k/bin/kompile").exists()
        && Path::new("k/bin/krun").exists()
        && Path::new("k/bin/k-configure-opam").exists();
}

pub fn recompile_model() -> Result<(), Box<dyn Error>> {
    Command::new("k/bin/kompiled")
        .args(&["-d", "model"])
        .output()?;
    Command::new("k/bin/k-configure-opam").output()?;

    Ok(())
}

pub fn is_osl_model_compiled() -> bool {
    Path::new("model/osl-kompiled").exists()
}

pub fn transpile_c_code(input: &PathBuf) -> Result<cfrontend::ast::Stmts, Vec<Box<dyn Error>>> {
    let source = input.to_string_lossy().into_owned();

    match lang_c::driver::parse(&Config::default(), &source) {
        Ok(ref ast) => {
            match cfrontend::transpile_c_program(ast.clone(), Configuration::new(true)) {
                Ok(stmts) => Ok(stmts),
                Err(err) => Err(format_errors_in_annotations_snippet(&ast.source, err)
                    .into_iter()
                    .map(Into::into)
                    .collect()),
            }
        }
        Err(LangCError::PreprocessorError(error)) => Err(vec![error.into()]),
        Err(LangCError::SyntaxError(error)) => Err(vec![DisplayList::from(Snippet {
            title: None,
            footer: vec![],
            slices: vec![Slice {
                source: error.source.as_str(),
                line_start: error.line,
                origin: None,
                fold: true,
                annotations: vec![SourceAnnotation {
                    label: error.to_string().as_str(),
                    annotation_type: AnnotationType::Error,
                    range: (error.column, error.offset),
                }],
            }],
            opt: FormatOptions {
                color: true,
                ..Default::default()
            },
        })
        .to_string()
        .into()]),
    }
}

// Run the krun script and get the output
pub fn krun(file: &PathBuf) -> Result<String, Box<dyn Error>> {
    let output = Command::new("k/bin/krun")
        .args(&["-d", "model"])
        .arg(format!("{}", file.to_string_lossy()))
        .output()?;

    if output.status.success() == false {
        // stderr may not crash the program
        convert_output(output.stderr.as_slice())?;
    }

    Ok(String::from_utf8(output.stdout.clone())?)
}

pub fn setup_opam() -> Result<(), Box<dyn Error>> {
    Command::new("eval").arg("$(opam env)").spawn();
    Ok(())
}

pub fn convert_output(output: &[u8]) -> Result<&str, Box<dyn Error>> {
    std::str::from_utf8(output).map_err(|e| e.into())
}

/// Check if the PGM in output is equal to <k>.<\k>
pub fn is_valid(k_output: &str) -> bool {
    Regex::new(r"<k>\n\s*\.\n\s*</k>")
        .unwrap()
        .is_match(k_output)
}

pub fn save_in_file(
    path_tmp_file: &PathBuf,
    stmts: cfrontend::ast::Stmts,
) -> Result<(), Box<dyn Error>> {
    let mut file = File::create(path_tmp_file)?;
    file.write_all(
        format!("{}", cfrontend::ast::render::render_program(stmts))
            .into_bytes()
            .as_slice(),
    )?;
    Ok(())
}

fn format_errors_in_annotations_snippet(
    source: &str,
    errors: Vec<TranspilationError>,
) -> Vec<String> {
    errors
        .into_iter()
        .map(|e| match e {
            TranspilationError::Unimplemented(span) => vec![unimplemented(source, span)],
            TranspilationError::Unsupported(span, reason) => {
                vec![unsupported(source, span, reason.as_str())]
            }
            TranspilationError::Unknown(span) => vec![unimplemented(source, span)],
            TranspilationError::Compound(errors) => {
                format_errors_in_annotations_snippet(source, errors)
            }
            TranspilationError::Message(msg) => vec![msg],
            TranspilationError::MessageSpan(span, msg) => {
                vec![report_error(source, span, msg.as_str())]
            }
            TranspilationError::NotTranspilable(span, reason) => {
                vec![unsupported(source, span, reason.as_str())]
            }
        })
        .flatten()
        .collect()
}

fn unimplemented(source: &str, span: Span) -> String {
    DisplayList::from(Snippet {
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
    })
    .to_string()
}

fn unsupported(source: &str, span: Span, reason: &str) -> String {
    DisplayList::from(Snippet {
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
    })
    .to_string()
}

fn report_error(source: &str, span: Span, message: &str) -> String {
    DisplayList::from(Snippet {
        title: None,
        footer: vec![],
        slices: vec![Slice {
            source: source,
            line_start: 0,
            origin: None,
            fold: true,
            annotations: vec![SourceAnnotation {
                label: message,
                annotation_type: AnnotationType::Error,
                range: (span.start, span.end),
            }],
        }],
        opt: FormatOptions {
            color: true,
            ..Default::default()
        },
    })
    .to_string()
}
