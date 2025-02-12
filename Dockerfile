ARG WRAPPER_COMMIT_HASH=f6ef44b2c449cca8f005b32dea9a4b497202dbef
ARG GO_TAG=1.24.0-alpine
ARG LSIO_WIREGUARD_TAG=1.0.20210914@sha256:c095b08123345cefa1a8a589a417c56690c046ba925d292f4657f3fefcce1dfd

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
