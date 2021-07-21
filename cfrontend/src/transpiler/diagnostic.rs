use annotate_snippets::{
    display_list::{DisplayList, FormatOptions},
    snippet::{AnnotationType, Slice, Snippet, SourceAnnotation},
};

use lang_c::span::Span;

#[derive(Debug)]
pub struct CodespanReporter {
    source: String,
}

impl CodespanReporter {
    pub fn new(source: String) -> Self {
        Self { source }
    }

    pub fn unimplemented(&self, span: Span) -> String {
        let snippet = Snippet {
            title: None,
            footer: vec![],
            slices: vec![Slice {
                source: self.source.as_str(),
                line_start: 0,
                origin: None,
                fold: true,
                annotations: vec![SourceAnnotation {
                    label: "not implemented",
                    annotation_type: AnnotationType::Error,
                    range: (span.start, span.end),
                }],
            }],
            opt: FormatOptions {
                color: true,
                ..Default::default()
            },
        };
        format!("{}", DisplayList::from(snippet))
    }

    pub fn info(&self, span: Span, label: &str) -> String {
        let snippet = Snippet {
            title: None,
            footer: vec![],
            slices: vec![Slice {
                source: self.source.as_str(),
                line_start: 0,
                origin: None,
                fold: true,
                annotations: vec![SourceAnnotation {
                    label,
                    annotation_type: AnnotationType::Info,
                    range: (span.start, span.end),
                }],
            }],
            opt: FormatOptions {
                color: true,
                ..Default::default()
            },
        };
        format!("{}", DisplayList::from(snippet))
    }

    pub fn help(&self, span: Span, label: &str) -> String {
        let snippet = Snippet {
            title: None,
            footer: vec![],
            slices: vec![Slice {
                source: self.source.as_str(),
                line_start: 0,
                origin: None,
                fold: true,
                annotations: vec![SourceAnnotation {
                    label,
                    annotation_type: AnnotationType::Help,
                    range: (span.start, span.end),
                }],
            }],
            opt: FormatOptions {
                color: true,
                ..Default::default()
            },
        };
        format!("{}", DisplayList::from(snippet))
    }
}
