FROM stephendolan/lucky:latest as builder
WORKDIR /app
COPY . .
RUN yarn install --no-progress
RUN yarn prod
RUN shards install --production
RUN crystal build --release src/start_server.cr -o bin/lucky-diff

FROM alpine
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/bin/lucky-diff /usr/local/bin/
CMD ["lucky-diff"]