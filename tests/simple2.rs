mod common;
use std::path::PathBuf;

#[test]
fn simple2_it_should_validate_convert_bin2dec() {
    assert!(common::is_valid(&PathBuf::from(r"tests/assets/convert_bin2dec.c")));
}

#[test]
fn simple2_it_should_validate_convert_dec2bin() {
    assert!(common::is_valid(&PathBuf::from(r"tests/assets/convert_dec2bin.c")));
}

#[test]
fn simple2_it_should_validate_check_primes() {
    assert!(common::is_valid(&PathBuf::from(r"tests/assets/check_primes.c")));
}

#[test]
fn simple2_it_should_validate_convert_oct2bin() {
    assert!(common::is_valid(&PathBuf::from(r"tests/assets/convert_oct2bin.c")));
}

#[test]
fn simple2_it_should_validate_convert_bin2oct() {
    assert!(common::is_valid(&PathBuf::from(r"tests/assets/convert_bin2oct.c")));
}