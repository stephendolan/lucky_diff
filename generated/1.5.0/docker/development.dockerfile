FROM crystallang/crystal:1.19.1

# Install utilities required to make this Dockerfile run
RUN apt-get update && \
    apt-get install -y wget curl unzip

# Apt installs:
# - Postgres cli tools are required for lucky-cli.
RUN apt-get update && \
    apt-get install -y postgresql-client && \
    rm -rf /var/lib/apt/lists/*

# Bun global installs:
#  - Bun is the default package manager for the asset component of a lucky
#    browser app.
RUN curl -fsSL https://bun.sh/install | bash
ENV BUN_INSTALL="/root/.bun"
ENV PATH="$BUN_INSTALL/bin:$PATH"

# Install lucky cli
WORKDIR /lucky/cli
RUN git clone https://github.com/luckyframework/lucky_cli . && \
    git checkout v1.5.0 && \
    shards build --without-development && \
    cp bin/lucky /usr/bin

WORKDIR /app
ENV DATABASE_URL=postgres://postgres:postgres@host.docker.internal:5432/postgres
EXPOSE 3000
EXPOSE 3001
