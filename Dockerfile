
From ubuntu:20.04

ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update

RUN apt install -y sudo

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN useradd -rm -d /home/alessio -s /bin/bash -g root -G sudo -u 1001 alessio

USER alessio

RUN echo $HOME

RUN sudo apt update

RUN sudo apt install --yes curl build-essential m4 openjdk-8-jre libgmp-dev libmpfr-dev pkg-config flex z3 libz3-dev unzip python3 opam perl tar sudo

# Get Rust; NOTE: using sh for better compatibility with other base images
#RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# Add .cargo/bin to PATH
ENV PATH="$HOME/.cargo/bin:${PATH}"

# Setup K-framework v3.6
COPY k /k

WORKDIR k

#RUN bin/k-configure-opam

ENV PATH="$PATH:/k/bin"

# Setup K-Framework OPAM package
WORKDIR /build

COPY build .

RUN sudo tar -xvf 4.03.1+k.tar.gz

RUN opam init --yes --disable-sandboxing

RUN cp -r 4.03.1+k $HOME/.opam/4.03.1+k

RUN cp config $HOME/.opam/config

RUN opam switch 4.03.1+k

RUN eval $(opam env)

RUN ocaml --version

WORKDIR /osl

COPY . .

WORKDIR /osl/model

RUN eval $(opam env)

ENV PATH="/home/alessio/.opam/4.03.1+k/bin:$PATH"

RUN ocaml --version

RUN echo $LD_LIBRARY_PATH

ENV LD_LIBRARY_PATH="/home/alessio/.opam/4.03.1+k/lib/stublibs/:${LD_LIBRARY_PATH}"

RUN kompile --backend ocaml osl.k || :

# Build OSL

#RUN rustup default nightly

#RUN cargo build --release

#CMD ./target/release/osl --help