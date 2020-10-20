FROM crystallang/crystal:0.35.1 as builder

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  nodejs \
  yarn \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/luckyframework/lucky_cli \
  && cd lucky_cli \
  && git checkout v0.24.0 \
  && shards install --production \
  && crystal build src/lucky.cr \
  && mv lucky /usr/local/bin
  
WORKDIR /app
COPY . .

RUN script/deploy/setup
RUN crystal build --release src/start_server.cr -o bin/lucky-diff

FROM alpine
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/bin/lucky-diff /usr/local/bin/
CMD ["lucky-diff"]