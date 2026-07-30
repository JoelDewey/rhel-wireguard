ARG WRAPPER_COMMIT_HASH=f6ef44b2c449cca8f005b32dea9a4b497202dbef
ARG GO_TAG=1.26.5-alpine
ARG LSIO_WIREGUARD_TAG=1.0.20260223@sha256:ac43e1226878d2611315172d6ea357a95cb326ee73124b91108118efc8666889

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
