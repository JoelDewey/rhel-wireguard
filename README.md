# rhel-wireguard

A Dockerfile that extends [`linuxserver/wireguard`](https://github.com/linuxserver/docker-wireguard) with the 
[`iptables-wrappers` scripts](https://github.com/kubernetes-sigs/iptables-wrappers) to support Red Hat or RHEL-derived 
distributions such as Fedora or AlmaLinux.

No warranty nor any kind of support is guaranteed for this container image. This repository is not affiliated with 
Red Hat, Kubernetes, or LinuxServer.io.

## Process

This Dockerfile:

1. Builds a specific commit hash of `iptables-wrapper` using a temporary Go container in the first build step.
2. Copies the `iptables-wrapper` build output to the final build step based off of a specific `linuxserver/wireguard` tag.
3. Installs `nftables` and runs the `iptables-wrapper` installation script.

The LinuxServer.io configuration then takes over and begins running Wireguard like the official image.

## References

Based off of the example given in [a feature request](https://github.com/linuxserver/docker-wireguard/issues/263) for 
`linuxserver/wireguard`.