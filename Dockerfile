ARG WRAPPER_COMMIT_HASH=f6ef44b2c449cca8f005b32dea9a4b497202dbef
ARG GO_TAG=1.27.4-alpine
ARG LSIO_WIREGUARD_TAG=1.0.20260223@sha256:30fcd4e2d5793935e3e3d913e3e874ecee27bc2bf01b2cb824a5cb01e02a1043

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
