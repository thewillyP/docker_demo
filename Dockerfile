FROM ghcr.io/astral-sh/uv:python3.13-bookworm-slim@sha256:f106758c361464e22aa1946c1338ae94de22ec784943494f26485d345dac2d85

ENV UV_COMPILE_BYTECODE=1

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    openssh-server \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd

SHELL ["/bin/bash", "-c"]

WORKDIR /workspace

COPY ./requirements.txt ./requirements.txt
COPY ./entrypoint.sh /entrypoint.sh

RUN uv pip install --system --no-cache -r requirements.txt \
    && chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]