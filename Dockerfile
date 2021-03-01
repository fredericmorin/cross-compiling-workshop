FROM ubuntu:latest as builder
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y \
# build
        build-essential \
        cmake \
        pkg-config \
# deps
        libpcap-dev \
    && rm -rf /var/lib/apt/lists/*
SHELL ["/bin/bash", "-c"]

FROM ubuntu:latest as runtime
RUN apt-get update && apt-get install --no-install-recommends -y \
# deps
        libpcap-dev \
    && rm -rf /var/lib/apt/lists/*
SHELL ["/bin/bash", "-c"]
