FROM ubuntu:focal as ci
ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]
RUN apt-get update && apt-get install --no-install-recommends -y \
# build
        build-essential \
        cmake \
# deps
        libpcap-dev \
# dind
        docker.io \
# download
        ca-certificates \
        wget \
# cross build
        g++-aarch64-linux-gnu \
# cross run
        proot \
        qemu-user \
    && rm -rf /var/lib/apt/lists/*
