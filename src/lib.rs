use cfrontend::configuration::Configuration;
use lang_c::driver::Config;
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

pub fn transpile_c_code(input: &PathBuf) -> Result<cfrontend::ast::Stmts, Box<dyn Error>> {
    let ast = lang_c::driver::parse(&Config::default(), input.to_string_lossy().into_owned())?;
    let stmts = cfrontend::transpile_c_program(ast, Configuration::new(true));

    Ok(stmts)
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
