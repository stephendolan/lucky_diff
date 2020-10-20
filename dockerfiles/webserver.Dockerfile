FROM crystallang/crystal:0.35.1-alpine as crystal_dependencies
ENV SKIP_LUCKY_TASK_PRECOMPILATION="1"
WORKDIR /tmp_crystal
COPY shard.yml shard.lock ./
RUN  shards install --production

FROM node:alpine as node_dependencies
WORKDIR /tmp_node
COPY package.json .
RUN yarn install

FROM node:alpine as webpack_build
WORKDIR /tmp_webpack
COPY . .
COPY --from=node_dependencies /tmp_node/node_modules node_modules
RUN yarn prod

FROM stephendolan/lucky:latest
ENV LUCKY_ENV=production
ENV NODE_ENV=production
WORKDIR /app
COPY . .
COPY --from=crystal_dependencies /tmp_crystal/lib lib
COPY --from=node_dependencies /tmp_node/node_modules node_modules
COPY --from=webpack_build /tmp_webpack/public public
RUN crystal build --release src/start_server.cr
CMD ["./start_server"]