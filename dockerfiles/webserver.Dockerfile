FROM stephendolan/lucky:latest as builder

ADD package.json /tmp/package.json
ADD yarn.lock /tmp/yarn.lock
RUN cd /tmp && yarn install --no-progress
RUN cp -a /tmp/node_modules /app/

ADD shard.yml /tmp/shard.yml
ADD shard.lock /tmp/shard.lock
RUN cd /tmp && shards install --production
RUN cp -a /tmp/lib /app/

WORKDIR /app
COPY . .
RUN yarn prod
RUN crystal build --release src/start_server.cr
CMD ["src/start_server"]