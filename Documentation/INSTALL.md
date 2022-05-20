# Building OSL


Here are instructions for installing OSL from the release tar.gz archive.
We recommend to use the Docker image way because the building of OSLos is broken due to [#24](https://github.com/NotBad4U/osl/issues/24).
Otherwise, for the more adventurous, if you still want to install OSL (OSLos + OSLτ + OSL-CLI) on your machine you can follow the step done in the [Dockerfile](../Dockerfile) to understand how to do it.

We have only tested this on Ubuntu focal (v20.04), although it may work on other distributions. Appropriate installation instructions and bug reports are welcome.


# Building OSL with Docker


The repository provides a `Dockerfile` to provide a self-contained environment.
Run the following in your terminal at the root directory to build the container:
```
docker build --rm -t osl .
```


Once OSL image is built, you can run it by executing the command:


```
docker run -it --rm osl /bin/bash
```


This command will start an interactive `bash` session by running the command.



# Building OSLτ and OSL-CLI on your machine


The compilation of OSLτ and OSL-CLI is not impacted by [#24](https://github.com/NotBad4U/osl/issues/24), so it is still possible to 
compile on your machine for a more comfortable development.


## Prerequisites


Run the following in your terminal to install Rust then follow the on-screen instructions.


```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```


More information could be found [here](https://www.rust-lang.org/tools/install).


## Build OSLτ and OSL-CLI


First, you will need the `nightly` version of Rust compiler because OSLτ use unstable feature.
This project has been developed with the `rustc 1.53.0-nightly` version.

You can install `nightly` allowing `rustup` to downgrade until it finds the components you need:
```sh
rustup toolchain install nightly --allow-downgrade --profile minimal --component clippy
```

and then you can switch to `nightly` version by running the command:

```sh
rustup default nightly
```

Finally, run the following in your terminal at the root directory to build OSLτ and OSL-CLI:

```sh
cargo build --release
```

# Test


Execute all the e2e tests by running this command at the root of the project:


```
cargo test
```