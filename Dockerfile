
From ubuntu:18.04

RUN apt update

RUN apt install --yes curl build-essential m4 openjdk-8-jre libgmp-dev libmpfr-dev pkg-config flex z3 libz3-dev unzip python3 opam perl

# Get Rust; NOTE: using sh for better compatibility with other base images
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# Add .cargo/bin to PATH
ENV PATH="/root/.cargo/bin:${PATH}"

# Setup K-framework v3.6
RUN eval $(opam env) 

COPY k k

WORKDIR k

ENV PATH="$PATH:/k/bin"

RUN ./bin/k-configure-opam

RUN eval $(opam env) 

WORKDIR /osl

COPY . .

# Build OSL

RUN rustup default nightly

RUN cargo build --release

CMD ./target/release/osl --help