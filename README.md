OSL: An Operational Semantics for Rust Language

[![Build Status](https://travis-ci.com/NotBad4U/osl.svg?branch=master)](https://travis-ci.com/NotBad4U/osl)

## Introduction

The Ownership System Language (OSL) aims to detect memory usage vulnerability such as _data-race_, _double-free_ and _use-after-free_ in C programs, through ownership system. The _Ownership_ is a set of rules that governs how a program must manages memory.


Currently, our system does not require manual notations on the C program analyzed. Ownership type systems could require considerable annotation overhead, which is a significant burden for users. The core of the tool is develop with the K-Framework, a rewrite-based executable semantic framework.

## Run OSL

You can find the build instructions in the document [INSTALL.md](Documentation/INSTALL.md).

You can run the OSL CLI by running the command:

```bash
cargo run -- <program.c> 
```

The optios available are:

```bash
USAGE:
    osl [FLAGS] [OPTIONS] <input>

FLAGS:
    -h, --help         Prints help information
    -k, --keep         Save temporary transpiled file
    -t, --transpile    Only run the transpiler
    -V, --version      Prints version information
    -v, --verbose      Use verbose output

OPTIONS:
    -o, --output <output>    Output C transpiled file

ARGS:
    <input>    Input C file
```

## Project structure

* `model`, which contains all the source code of OSLos
* `cfrontend`, which contains all the source code of OSLτ 
* `src`, which provides the source code of the CLI of OSL binary. It pipe OSLτ and OSLos.  
* `tests`, which contains a stack of tests that can be run automaticaly.
* `Documentation`,  which is used to store doc files and draft publication.

### Development

You can find tests of the semantics in the folder: `model/tests`.
Use them to control breaking changes and help in the development.

The integration tests can be find in the folder `tests`.

The unit tests for OSLτ can be find in the folder `cfrontend/tests`.