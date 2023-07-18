FROM golang:1.20-alpine as build

WORKDIR /go

RUN apk add git make
RUN git clone https://github.com/kubernetes-sigs/iptables-wrappers.git code \
    && cd code \
    && git checkout 5792812d9e5a5bb7f22d79d557bbfeece253343d
RUN (cd code && make build)

FROM linuxserver/wireguard:v1.0.20210914-ls123

COPY --from=build /go/code/iptables-wrapper-installer.sh /
COPY --from=build /go/code/bin/iptables-wrapper /
RUN apk add --no-cache nftables && bash /iptables-wrapper-installer.sh
