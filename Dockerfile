ARG WRAPPER_COMMIT_HASH=f6ef44b2c449cca8f005b32dea9a4b497202dbef
ARG GO_TAG=1.24.4-alpine
ARG LSIO_WIREGUARD_TAG=1.0.20210914@sha256:6a47538303a74c4c8cd2566d5bca52816856104b9438550d3de9ded3cb5d1235

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
