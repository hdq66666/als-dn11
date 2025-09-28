FROM node:lts-alpine as builderNodeJSCache
ADD ui/package.json /app/package.json
WORKDIR /app
RUN npm i

FROM node:lts-alpine as builderNodeJS
ADD ui /app
WORKDIR /app
COPY --from=builderNodeJSCache /app/node_modules /app/node_modules
RUN npm run build \
    && chmod -R 650 /app/dist

FROM alpine:3 as builderGolang
ADD backend /app
WORKDIR /app
COPY --from=builderNodeJS /app/dist /app/embed/ui
RUN apk add --no-cache go 

RUN go build -o als && \
    chmod +x als

FROM alpine:3 as builderEnv
WORKDIR /app
ADD scripts /app
RUN sh /app/install-software.sh
RUN apk add --no-cache \
    iperf iperf3 \
    mtr \
    traceroute \
    iputils
RUN rm -rf /app

FROM alpine:3
LABEL maintainer="samlm0 <update@ifdream.net>"
COPY --from=builderEnv / /
COPY --from=builderGolang --chmod=755 /app/als/als /bin/als
COPY --chmod=755 scripts/ntr-wrapper.sh /usr/local/bin/ntr
COPY --chmod=755 scripts/ntr-sync.sh /usr/local/bin/ntr-sync.sh
COPY --chmod=755 scripts/ntr-runtime.sh /usr/local/bin/ntr-runtime.sh

CMD ["/usr/local/bin/ntr-runtime.sh"]
