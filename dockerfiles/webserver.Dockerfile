FROM node:alpine as node_dependencies
WORKDIR /tmp
COPY package.json yarn.lock /tmp/
RUN  yarn install --no-progress

FROM crystallang/crystal:0.35.1-alpine as crystal_dependencies
ENV SKIP_LUCKY_TASK_PRECOMPILATION="1"
WORKDIR /tmp
COPY shard.yml shard.lock /tmp/
RUN  shards install --production

FROM node:alpine as webpack_build
WORKDIR /tmp
COPY . .
RUN yarn prod

FROM stephendolan/lucky:latest
WORKDIR /app
COPY . .
COPY --from=node_dependencies /tmp/node_modules ./node_modules
COPY --from=crystal_dependencies /tmp/lib ./lib
COPY --from=webpack_build /tmp/public public
RUN crystal build --release src/start_server.cr
CMD ["src/start_server"]