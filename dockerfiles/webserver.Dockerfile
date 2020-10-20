FROM stephendolan/lucky:latest as node_dependencies
COPY package.json yarn.lock /tmp/
RUN cd /tmp && yarn install --no-progress

FROM stephendolan/lucky:latest as crystal_dependencies
COPY shard.yml shard.lock /tmp/
RUN cd /tmp && shards install --production

FROM stephendolan/lucky:latest
WORKDIR /app
COPY . .
COPY --from=node_dependencies /tmp/node_modules ./node_modules
COPY --from=crystal_dependencies /tmp/lib ./lib
RUN yarn prod
RUN crystal build --release src/start_server.cr
CMD ["src/start_server"]