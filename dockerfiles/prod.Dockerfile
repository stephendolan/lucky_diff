FROM crystallang/crystal:0.35.1 as builder
WORKDIR /app
COPY . .
RUN git clone https://github.com/luckyframework/lucky_cli \
  && cd lucky_cli \
  && git checkout v0.24.0 \
  && shards install --production \
  && crystal build src/lucky.cr \
  && mv lucky /usr/local/bin
RUN ./script/setup_prod
RUN crystal build --release src/start_server.cr -o bin/lucky-diff

FROM alpine
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/bin/lucky-diff /usr/local/bin/
CMD ["lucky-diff"]