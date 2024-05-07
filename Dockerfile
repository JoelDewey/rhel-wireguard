ARG WRAPPER_COMMIT_HASH=5792812d9e5a5bb7f22d79d557bbfeece253343d
ARG GO_TAG=1.22.3-alpine
ARG LSIO_WIREGUARD_TAG=version-v1.0.20210914@sha256:b0e317bc390e2d12339648920d2148f17fd28f7544fe77ebe864fdb0dc857474

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
