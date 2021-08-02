OSL: An Operational Semantics for Rust Language

[![Build Status](https://travis-ci.com/NotBad4U/osl.svg?branch=master)](https://travis-ci.com/NotBad4U/osl)

## Introduction

OSL semantics is an operational semantics implemented in K-Framework,

which is a rewrite logic based formal modeling tool.

## Dependencies

In order to run the semantics, K-framework should be installed.

The project already contain a version of K-framework that you can use.

But if you want to use your own version, We suggest to install a release compatible with this one, which has been used for the development of OSL:

https://github.com/kframework/k/releases/tag/nightly-f5ea5c7

Other versions nmay arise some problems when compile and run OSL programs.

## Project structure

* `model`: source files of OSL semantic
* `document`: documentation
* `report`: Latex source of the OSL report
* `k`: The K release `nightly-f5ea5c7`

*Please ignore cfrontend folder for now*

## Run OSL semantic

**1. Setup Ocaml**

Run the configure script provide by K-framework `3.5` by running this command at the root folder of the project: 

```sh
./k/bin/k-configure-opam
eval $(opam config env)
```

**2. Compile the semantic**

The project provide a `Makefile`, so just run the following commands:
```sh
cd model
make
```

Or if you want to provide your own argument run the commands:
```sh
cd model
../k/bin/kompile osl.k --backend ocaml [ARGS]
```

**3. Run the example**

The project provide some demos.
You can try OSL by running this command in the `model` folder:

```sh
../k/bin/krun t4.rs
```
or

```sh
../k/bin/krun demo/demo.c
```

### Development

You can find tests programs in the folder: `model/tests`.
Use them to control breaking changes and help in the development.
