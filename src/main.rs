#[macro_use]
extern crate log;

use cfrontend::configuration::Configuration;
use env_logger::Builder;
use lang_c::driver::Config;
use log::LevelFilter;
use regex::Regex;
use structopt::StructOpt;

use std::error::Error;
use std::fmt;
use std::fs::File;
use std::io::{self, Write};
use std::path::Path;
use std::path::PathBuf;
use std::process::Command;

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

    let osl_file = opt.output.clone().unwrap_or(PathBuf::from(format!(
        "{}.osl",
        opt.input.to_string_lossy()
    )));

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
    transpile_c_code(&opt, &osl_file.to_string_lossy())?;

    if opt.only_transpile == false {
        info!("[5/5] Running OSL");
        let k_output = krun(&osl_file)?;

        if is_valid(k_output.as_str()) {
            info!("Program valid ✓")
        } else {
            error!("Program invalid ✘");
            io::stdout().write_all(k_output.as_bytes())?;
        }
    } else {
        info!("[5/5] dry-run mode active, krun will not be started")
    }

    if opt.keep == false {
        trace!("Deleting OSL file {}", osl_file.to_string_lossy());
        std::fs::remove_file(osl_file)?;
    }

    Ok(())
}

//TODO: Check in $PATH also
fn are_k_bins_installed() -> bool {
    return Path::new("k/bin/kompile").exists()
        && Path::new("k/bin/krun").exists()
        && Path::new("k/bin/k-configure-opam").exists();
}

fn recompile_model() -> Result<(), Box<dyn Error>> {
    trace!("k/bin/kompiled -d model");
    Command::new("k/bin/kompiled")
        .args(&["-d", "model"])
        .output()?;

    trace!("k/bin/k-configure-opam");
    Command::new("k/bin/k-configure-opam").output()?;

    Ok(())
}

fn is_osl_model_compiled() -> bool {
    Path::new("model/osl-kompiled").exists()
}

fn transpile_c_code(opt: &Opt, output_file_name: &str) -> Result<(), Box<dyn Error>> {
    info!("parsing {}...", opt.input.to_string_lossy());
    let ast = lang_c::driver::parse(&Config::default(), opt.input.to_string_lossy().into_owned())?;

    info!("transpiling {}...", opt.input.to_string_lossy());
    let stmts = cfrontend::transpile_c_program(ast, Configuration::new(true));

    if opt.only_transpile && !opt.keep {
        println!("{}", stmts);
    } else {
        trace!("creating temporary file: {}", output_file_name);
        let mut file = File::create(output_file_name)?;
        file.write_all(
            format!("{}", cfrontend::ast::render::render_program(stmts))
                .into_bytes()
                .as_slice(),
        )?;
    }

    Ok(())
}

// Run the krun script and get the output
fn krun(file: &PathBuf) -> Result<String, Box<dyn Error>> {
    trace!("k/bin/krun -d model {}", file.to_string_lossy());
    let output = Command::new("k/bin/krun")
        .args(&["-d", "model"])
        .arg(format!("{}", file.to_string_lossy()))
        .output()?;

    if output.status.success() == false {
        // stderr may not crash the program
        let msg = convert_output(output.stderr.as_slice())?;
        error!("{}\n{}", output.status, msg);
    }

    Ok(String::from_utf8(output.stdout.clone())?)
}

fn setup_opam() -> Result<(), Box<dyn Error>> {
    trace!("eval $(opam env)");
    Command::new("eval").arg("$(opam env)").spawn();
    Ok(())
}

fn convert_output(output: &[u8]) -> Result<&str, Box<dyn Error>> {
    std::str::from_utf8(output).map_err(|e| e.into())
}

/// Check if the PGM in output is equal to <k>.<\k>
fn is_valid(k_output: &str) -> bool {
    Regex::new(r"<k>\n\s*\.\n\s*</k>")
        .unwrap()
        .is_match(k_output)
}
