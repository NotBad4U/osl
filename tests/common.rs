
use osl;
use std::path::PathBuf;

#[allow(dead_code)]
pub fn is_valid(path: &PathBuf) -> bool {
    let mut tmp_test_file_name = PathBuf::from(path.iter().last().unwrap());
    tmp_test_file_name.set_extension("osl");

    let stmts = osl::transpile_c_code(path).expect("cannot transpile");

    let mut test_tmp_file = PathBuf::from(r"tests/").join(tmp_test_file_name);
    osl::save_in_file(&test_tmp_file, stmts);

    let k_output = osl::krun(&test_tmp_file).expect("cannot execute krun");

    std::fs::remove_file(&test_tmp_file).expect(&format!(
        "cannot remove the temporary file {:?}",
        test_tmp_file.to_str()
    ));

    // Uncomment this line to get the output return by K.
    let is_valid = osl::is_valid(k_output.as_str());

    if is_valid == false {
        let output =  osl::serialize_k_output(k_output.as_str());
        output.states.state.iter().for_each(|state| {
            println!("{}", state.k);
            println!("{}", state.store);
            println!("{}", state.env);
            println!("----");
        })
    }

    is_valid
}
