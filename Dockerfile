FROM bitnami/git AS git
WORKDIR /app

ARG VERSION=1.52.0

RUN git clone --recurse-submodules https://github.com/Li-Yaosong/old-demo.git webadb
WORKDIR /app/webadb
FROM node:20 AS build

COPY --from=git /app/webadb /app/webadb
WORKDIR /app/webadb
RUN npm install -g pnpm
RUN pnpm install
RUN pnpm recursive run build

FROM node:20 AS final
COPY --from=build /app/webadb /app/webadb
RUN npm install -g pnpm
WORKDIR /app/webadb/packages/demo

EXPOSE 3000
