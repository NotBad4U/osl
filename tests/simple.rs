mod common;
use std::path::Path;
use std::path::PathBuf;

#[test]
fn it_should_validate_hello_world() {
    assert!(common::is_valid(&PathBuf::from(r"tests/assets/hello.c")));
}

#[test]
fn it_should_validate_even_odd() {
    assert!(common::is_valid(&PathBuf::from(
        r"tests/assets/check_leap_year.c"
    )));
}

#[test]
fn it_should_validate_swap_number() {
    assert!(common::is_valid(&PathBuf::from(
        r"tests/assets/swap_number.c"
    )));
}

#[test]
fn it_should_not_validate_borrow_clash() {
    assert!(common::is_valid(&PathBuf::from(r"tests/assets/borrow_clash.c")) == false);
}

#[test]
fn it_should_validate_borrow_clash_when_in_unsafe_block() {
    assert!(common::is_valid(&PathBuf::from(
        r"tests/assets/borrow_clash_unsafe.c"
    )));
}

#[test]
fn it_should_validate_simple_RSA() {
    assert!(common::is_valid(&PathBuf::from(
        r"tests/assets/simple_rsa.c"
    )));
}

#[test]
fn it_should_not_validate_double_free() {
    assert!(common::is_valid(&PathBuf::from(r"tests/assets/double_free.c")) == false);
}
