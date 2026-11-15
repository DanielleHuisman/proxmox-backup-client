FROM rust:trixie

RUN apt-get update && apt-get install -y --no-install-recommends \
    libacl1-dev libfuse3-dev libssl-dev libsystemd-dev patchelf pkg-config python3 python3-pip zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

COPY --from=ghcr.io/astral-sh/uv:0.13.6 /uv /uvx /usr/local/bin/

ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME
USER $USERNAME

RUN rustup component add clippy rustfmt

RUN uv tool install maturin
ENV PATH="/home/$USERNAME/.local/bin:${PATH}"

WORKDIR /workspace
