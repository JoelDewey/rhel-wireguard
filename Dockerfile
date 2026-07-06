ARG WRAPPER_COMMIT_HASH=f6ef44b2c449cca8f005b32dea9a4b497202dbef
ARG GO_TAG=1.26.2-alpine
ARG LSIO_WIREGUARD_TAG=1.0.20250521@sha256:f33891344345b1f78705e723b633e3a3f94d08ae75ca1a5f48c5a449c35bf460

FROM golang:${GO_TAG} as build

WORKDIR /go

RUN apk add git make
RUN git clone https://github.com/kubernetes-sigs/iptables-wrappers.git code \
    && cd code \
    && git checkout $WRAPPER_COMMIT_HASH
RUN (cd code && make build)

FROM linuxserver/wireguard:${LSIO_WIREGUARD_TAG}

COPY --from=build /go/code/bin/iptables-wrapper /
RUN apk add --no-cache nftables iptables-legacy && /iptables-wrapper install
