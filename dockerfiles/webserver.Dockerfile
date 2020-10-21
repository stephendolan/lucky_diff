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
ENV NODE_ENV=production
WORKDIR /tmp_webpack
COPY . .
COPY --from=node_dependencies /tmp_node/node_modules node_modules
RUN yarn prod

FROM crystallang/crystal:0.35.1-alpine as binary_build
ENV LUCKY_ENV=production
WORKDIR /tmp_binary_build
COPY . .
COPY --from=crystal_dependencies /tmp_crystal/lib lib
COPY --from=webpack_build /tmp_webpack/public public
RUN crystal build --static --release src/start_server.cr -o /usr/local/bin/lucky-app

FROM alpine
ENV LUCKY_ENV=production
ENV NODE_ENV=production
WORKDIR /app
COPY --from=binary_build /usr/local/bin/lucky-app lucky-app
COPY --from=webpack_build /tmp_webpack/public public
CMD ["./lucky-app"]