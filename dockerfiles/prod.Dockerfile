FROM crystallang/crystal:0.35.1-alpine as builder
WORKDIR /app
COPY . .
RUN git clone https://github.com/luckyframework/lucky_cli \
  && cd lucky_cli \
  && git checkout v0.24.0 \
  && shards install \
  && crystal build src/lucky.cr \
  && mv lucky /usr/local/bin
RUN script/setup
RUN crystal build --release src/start_server.cr -o bin/lucky-diff

FROM alpine
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/bin/lucky-diff /usr/local/bin/
CMD ["lucky-diff"]