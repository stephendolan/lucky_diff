FROM stephendolan/lucky:latest as builder
WORKDIR /app
COPY . .
RUN yarn install --no-progress
RUN yarn prod
RUN shards install --production
RUN crystal build --release src/start_server.cr -o bin/lucky-diff
CMD ["bin/lucky-diff"]