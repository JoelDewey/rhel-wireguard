ARG WRAPPER_COMMIT_HASH=5792812d9e5a5bb7f22d79d557bbfeece253343d
ARG GO_TAG=1.22.2-alpine
ARG LSIO_WIREGUARD_TAG=version-v1.0.20210914@sha256:c417568c79a051a8a73ffc2ad28ef58f58ba76bdb4c420389819c001aa55a03e

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
