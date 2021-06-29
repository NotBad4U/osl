#[macro_use] extern crate log;

use std::process::exit;

use lang_c::driver::Config;
use lang_c::visit::Visit;

mod osl;

use crate::osl::CVisitorToOsl;

fn main() {
    env_logger::init();

    let mut config = Config::default();
    let mut source = None;
    let mut quiet = false;

    for opt in std::env::args().skip(1) {
        if opt == "gcc" {
            config = Config::with_gcc();
        } else if opt == "clang" {
            config = Config::with_clang();
        } else if opt == "-q" {
            quiet = true;
        } else if opt.starts_with("-") {
            config.cpp_options.push(opt);
        } else {
            if source.is_none() {
                source = Some(opt);
            } else {
                info!("multiple input files given");
                exit(1);
            }
        }
    }

    let source = match source {
        Some(s) => s,
        None => {
            info!("input file required");
            exit(1);
        }
    };

    match lang_c::driver::parse(&config, &source) {
        Ok(parse) => {
            let mut cvisitor = CVisitorToOsl{};
            cvisitor.visit_translation_unit(&parse.unit);
        }
        Err(err) => {
            error!("{}", err);
            exit(1);
        }
    }
}
