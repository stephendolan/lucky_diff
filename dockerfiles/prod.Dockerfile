FROM crystallang/crystal:0.35.1-alpine as builder
WORKDIR /app
COPY . .
RUN shards install
RUN crystal build --release src/start_server.cr -o bin/lucky-diff

FROM alpine
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/bin/lucky-diff /usr/local/bin/
CMD ["lucky-diff"]