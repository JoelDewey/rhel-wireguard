ARG WRAPPER_COMMIT_HASH=5792812d9e5a5bb7f22d79d557bbfeece253343d
ARG GO_TAG=1.21.6-alpine
ARG LSIO_WIREGUARD_TAG=version-v1.0.20210914@sha256:28636a8aae70b379965eb12da8203b1829d4bd39a6495632befbea1dc3073c5a

FROM golang:${GO_TAG} as build

WORKDIR /go

RUN apk add git make
RUN git clone https://github.com/kubernetes-sigs/iptables-wrappers.git code \
    && cd code \
    && git checkout $WRAPPER_COMMIT_HASH
RUN (cd code && make build)

FROM linuxserver/wireguard:${LSIO_WIREGUARD_TAG}

COPY --from=build /go/code/iptables-wrapper-installer.sh /go/code/bin/iptables-wrapper /
RUN apk add --no-cache nftables && bash /iptables-wrapper-installer.sh
