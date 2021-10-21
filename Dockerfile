FROM rust:alpine3.14 AS builder

RUN apk add musl-dev build-base openssl-dev libsass-dev oniguruma-dev

WORKDIR /usr/src/zola
COPY zola/ .
# Download the package separate to increase build time when rebuild
RUN cargo fetch

# Tell it to link against system library
ENV RUSTONIG_SYSTEM_LIBONIG=1
# Fix dynamic link issues
# On musl targets, it's required to force turn off static crt
# when building dynamic link binary
ENV RUSTFLAGS="-C target-feature=-crt-static"

# Build the binary
RUN cargo install --path .

FROM alpine:3.14

RUN apk add musl libgcc libsass oniguruma

COPY --from=builder /usr/local/cargo/bin/zola /usr/local/bin/zola
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

