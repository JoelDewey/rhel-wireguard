ARG WRAPPER_COMMIT_HASH=f6ef44b2c449cca8f005b32dea9a4b497202dbef
ARG GO_TAG=1.26.2-alpine
ARG LSIO_WIREGUARD_TAG=1.0.20250521@sha256:33d861fd6ebcdc0f8d946ace22fa1efc2e3fc81951028bca2dea65f40fe05f93

FROM golang:${GO_TAG} as build

WORKDIR /go

RUN apk add git make
RUN git clone https://github.com/kubernetes-sigs/iptables-wrappers.git code \
    && cd code \
    && git checkout $WRAPPER_COMMIT_HASH
RUN (cd code && make build)

FROM linuxserver/wireguard:${LSIO_WIREGUARD_TAG}

COPY --from=build /go/code/iptables-wrapper-installer.sh /go/code/bin/iptables-wrapper /
RUN apk add --no-cache nftables iptables-legacy && bash /iptables-wrapper-installer.sh
