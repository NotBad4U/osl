
From ubuntu:20.04

# During a Docker image build – it stops asking to configure the tzdata.
# To avoid this data-enter request, especially when such build is running on CI like Jenkins – we configure tzdata 
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update

# We will need sudo for the non-root user that we will create
RUN apt install -y sudo

# We inject the opam K-Framework dependencies by hand because the opam switch 4.03.1+k does not exists anymore (see INSTALL.md for more details about this issues).
# For that we need to create the user alessio because some configuration files have /home/alessio as a path of some parameters. 
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN useradd -rm -d /home/alessio -s /bin/bash -g root -G sudo -u 1001 alessio

USER alessio

RUN sudo apt update

RUN sudo apt install --yes curl build-essential m4 openjdk-8-jre libgmp-dev libmpfr-dev pkg-config flex z3 libz3-dev unzip python3 opam perl tar sudo

# SETUP K-framework v3.6
COPY k /k

WORKDIR k

ENV PATH="$PATH:/k/bin"

# SETUP K-Framework OPAM package
WORKDIR /build

COPY build .

RUN sudo tar -xvf 4.03.1+k.tar.gz

RUN opam init --yes --disable-sandboxing

RUN cp -r 4.03.1+k $HOME/.opam/4.03.1+k

RUN cp config $HOME/.opam/config

RUN opam switch 4.03.1+k

RUN eval $(opam env)

# SETUP Osl

WORKDIR /osl

COPY . .

## SETUP the OSL model based on K-Framework

WORKDIR /osl/model

RUN eval $(opam env)

ENV PATH="/home/alessio/.opam/4.03.1+k/bin:$PATH"

ENV LD_LIBRARY_PATH="/home/alessio/.opam/4.03.1+k/lib/stublibs/:${LD_LIBRARY_PATH}"

# The compilation of the model might exit with a non-zero code and make the build stop.
# We ignore the non-zero code by using "|| :" 
RUN kompile --backend ocaml osl.k || :

# Build OSL-CLI and OSLτ

# Get Rust; NOTE: using sh for better compatibility with other base images
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# Add .cargo/bin to PATH
ENV PATH="/home/alessio/.cargo/bin:${PATH}"

RUN sudo chown -R $(whoami) /osl

WORKDIR /osl

RUN rustup default nightly

RUN cargo build --release

ENTRYPOINT ./target/release/osl

CMD "--help"