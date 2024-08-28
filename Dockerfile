FROM bitnami/git AS git
WORKDIR /app

ARG VERSION=1.52.0

RUN git clone --recurse-submodules https://github.com/tango-adb/demo-nodejs.git webadb
WORKDIR /app/webadb
FROM node:20 AS build

COPY --from=git /app/webadb /app/webadb
WORKDIR /app/webadb
RUN npm install -g pnpm
RUN pnpm recursive i
RUN pnpm recursive run build

FROM node:20 AS final
COPY --from=build /app/webadb /app/webadb
WORKDIR /app/webadb/server
#docker-entrypoint.sh
RUN echo "#!/bin/sh" > /app/webadb/docker-entrypoint.sh
RUN echo "cd /app/webadb/server" >> /app/webadb/docker-entrypoint.sh
RUN echo "pnpm run start & cd /app/webadb/client && pnpm run start" >> /app/webadb/docker-entrypoint.sh
RUN chmod +x /app/webadb/docker-entrypoint.sh
CMD ["/app/webadb/docker-entrypoint.sh"]
EXPOSE 8081
EXPOSE 3000
