FROM node:alpine as node_dependencies
ENV NODE_ENV=production
WORKDIR /tmp
COPY package.json yarn.lock /tmp/
RUN yarn install --no-progress
RUN yarn prod

FROM crystallang/crystal:0.35.1-alpine as crystal_dependencies
ENV SKIP_LUCKY_TASK_PRECOMPILATION="1"
WORKDIR /tmp
COPY shard.yml shard.lock /tmp/
RUN  shards install --production

FROM stephendolan/lucky:latest
ENV LUCKY_ENV=production
WORKDIR /app
COPY . .
COPY --from=crystal_dependencies /tmp/lib lib
COPY --from=node_dependencies /tmp/node_modules node_modules
COPY --from=node_dependencies /tmp/public public
RUN crystal build --release src/start_server.cr
CMD ["start_server"]