FROM rust:alpine3.14 AS builder

RUN apk add musl-dev build-base

WORKDIR /usr/src/zola
COPY zola/ .
# Download the package separate to increase build time when rebuild
RUN cargo fetch
# Build the binary
RUN cargo install --path .

FROM alpine:3.14
COPY --from=builder /usr/local/cargo/bin/zola /usr/local/bin/zola
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

