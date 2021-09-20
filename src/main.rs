#[macro_use]
extern crate log;

use env_logger::Builder;
use log::LevelFilter;
use structopt::StructOpt;

use std::error::Error;
use std::fmt;
use std::io::{self, Write};
use std::path::PathBuf;

use osl::*;

#[derive(Debug)]
enum OslError {
    KbinsMissing,
}

impl fmt::Display for OslError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match *self {
            Self::KbinsMissing => write!(
                f,
                "{}",
                "K binaries are missing. This program need at least the script kompile and krun.\n
                Please download this version https://github.com/kframework/k/releases/tag/nightly-f5ea5c7.",
            ),
        }
    }
}

impl Error for OslError {
    fn description(&self) -> &str {
        match *self {
            Self::KbinsMissing => {
                "K binaries are missing. This program need at least the script kompile and krun.\n
                Please download this version https://github.com/kframework/k/releases/tag/nightly-f5ea5c7."
            }
        }
    }
}

#[derive(Debug, StructOpt)]
#[structopt(name = "osl", about = "An example of StructOpt usage.")]
struct Opt {
    /// Input C file
    #[structopt(parse(from_os_str))]
    input: PathBuf,

    /// Only run the transpiler
    #[structopt(name = "transpile", short, long)]
    only_transpile: bool,

    /// Save temporary transpiled file
    #[structopt(short, long)]
    keep: bool,

    /// Use verbose output
    #[structopt(short, long)]
    verbose: bool,

    /// Output C transpiled file
    #[structopt(short, long, parse(from_os_str))]
    output: Option<PathBuf>,
}

fn main() -> Result<(), Box<dyn Error>> {
    let opt = Opt::from_args();

    let mut builder = Builder::from_default_env();

    if opt.verbose {
        builder.filter(None, LevelFilter::Trace).init();
    } else {
        builder.filter(None, LevelFilter::Info).init();
    }

    info!("[1/5] Checking K installation");
    if are_k_bins_installed() == false {
        return Err(Box::new(OslError::KbinsMissing));
    }

    info!("[2/5] Checking OSL model installation");
    if is_osl_model_compiled() == false {
        info!("OSL is not compiled. Trying to recompile it");
        recompile_model()?;
    }

    info!("[3/5] Configure opam");
    setup_opam()?;

    info!("[4/5] Transpiling {}", opt.input.to_string_lossy());
    match transpile_c_code(&opt.input) {
        Ok(stmts) => {
            if opt.only_transpile {
                info!("[5/5] dry-run mode active, krun will not be started");
                println!("{}", cfrontend::ast::render::render_program(stmts));
                return Ok(());
            }

            let osl_file_tmp = opt.output.clone().unwrap_or(PathBuf::from(format!(
                "{}.osl",
                opt.input.to_string_lossy()
            )));

            save_in_file(&osl_file_tmp, stmts)?;

            info!("[5/5] Running OSL");
            let k_output = krun(&osl_file_tmp)?;

            if is_valid(k_output.as_str()) {
                info!("Program valid ✓")
            } else {
                error!("Program invalid ✘");
                io::stdout().write_all(k_output.as_bytes())?;
            }

            if opt.keep == false {
                trace!("Deleting OSL file {}", osl_file_tmp.to_string_lossy());
                std::fs::remove_file(osl_file_tmp)?;
            }

            Ok(())
        }
        Err(errors) => {
            errors.iter().for_each(|err| eprintln!("{}", err));
            Err("Cannot transpile the C program".into())
        }
    }
}
