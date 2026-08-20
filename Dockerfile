ARG WRAPPER_COMMIT_HASH=f6ef44b2c449cca8f005b32dea9a4b497202dbef
ARG GO_TAG=1.27.0-alpine
ARG LSIO_WIREGUARD_TAG=1.0.20260223@sha256:3abfd4b82212106e357989750b9c0c9859aa511f5305a9a55c18c8de7198b655

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
