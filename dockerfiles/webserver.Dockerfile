FROM crystallang/crystal:0.35.1-alpine as crystal_dependencies
ENV SKIP_LUCKY_TASK_PRECOMPILATION="1"
WORKDIR /tmp_crystal
COPY shard.yml shard.lock /tmp/
RUN  shards install --production

FROM node:slim as node_dependencies
ENV NODE_ENV=production
WORKDIR /tmp_node
COPY package.json .
RUN yarn install

FROM node:slim as webpack_build
ENV NODE_ENV=production
WORKDIR /tmp_webpack
COPY . .
RUN yarn prod

FROM stephendolan/lucky:latest
ENV LUCKY_ENV=production
WORKDIR /app
COPY . .
COPY --from=crystal_dependencies /tmp_crystal/lib lib
COPY --from=node_dependencies /tmp_node/node_modules node_modules
COPY --from=webpack_build /tmp_webpack/public public
RUN crystal build --release src/start_server.cr
CMD ["start_server"]