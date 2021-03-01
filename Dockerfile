FROM ubuntu:focal as runtime
ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]
RUN apt-get update && apt-get install --no-install-recommends -y \
# deps
        libpcap-dev \
    && rm -rf /var/lib/apt/lists/*

FROM runtime as builder
RUN apt-get update && apt-get install --no-install-recommends -y \
# build
        build-essential \
        cmake \
        pkg-config \
    && rm -rf /var/lib/apt/lists/*
