# Building OSL manually

Here are instructions for installing OSL from the release tar.gz archive.

We have only tested this on Ubuntu focal (v20.04), although it may work on other distributions. Appropriate installation instructions and bug reports are welcome.

## Prerequisites

### K-framework

Package dependencies for K-framework:

```bash
sudo apt-get update; sudo apt-get install build-essential m4 openjdk-8-jre libgmp-dev libmpfr-dev pkg-config flex z3 libz3-dev unzip python3
```

### Rust-lang

Run the following in your terminal to install Rust then follow the on-screen instructions.

```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

More information could be find [here](https://www.rust-lang.org/tools/install).

## Install K-framework

Once `opam` is installed, you can prepare the installation to run the OCAML backend by running the `k-configure-opam` script found in the `bin` subdirectory in the `k` directory. You will also need to run eval `opam config env` afterwards to update your environment. This script will add the new opam prefix `4.03.1+k_` and download the opam packages: mlgmp, zarith, uuidm.

We recommand to add the direction `k/bin` to your `$PATH` environment.

## Build OSLos

Once K-framework is installed, you can install oslos by running the command in the `model` directory.

```
kompile osl.k --backend ocaml osl
```

This will produce an `osl-kompiled` directory that contains the compiled model of OSLos.

## Build OSLτ and OSL-CLI

Run the following in your terminal at the root directory:

```sh
cargo build --release
```

## Test

Execute all the e2e tests by running this command at the root of project:

```
cargo test
```

# Building OSL with Docker

The repository provides a `Dockerfile` to provide a self contained environment.
Run the following in your terminal at the root directory to build the container:
```
docker build --rm -t osl .
```

Once OSL image is built, you can run it by executing the command:

```
docker run -it --rm osl /bin/bash
```

This command will start an interactive `bash` session by running the command.
