mod common;

use std::path::PathBuf;

#[test]
fn medium_it_should_validate_serverhttp() {
    assert!(common::is_valid(&PathBuf::from(r"tests/assets/serverhttp.c")));
}

#[test]
fn medium_it_should_validate_n_queen_problem() {
    assert!(common::is_valid(&PathBuf::from(r"tests/assets/n_queen_problem.c")));
}

#[test]
fn medium_it_should_validate_rsa() {
    assert!(common::is_valid(&PathBuf::from(
        r"tests/assets/simple_rsa.c"
    )));
}