FROM rust:alpine3.14 AS builder

RUN apk add musl-dev build-base openssl-dev libsass-dev oniguruma-dev

WORKDIR /usr/src/zola
COPY zola/ .
# Download the package separate to increase build time when rebuild
RUN cargo fetch
# Build the binary
ENV RUSTONIG_SYSTEM_LIBONIG=1
RUN cargo install --path .

FROM alpine:3.14

RUN apk add musl libgcc libsass oniguruma

COPY --from=builder /usr/local/cargo/bin/zola /usr/local/bin/zola
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

