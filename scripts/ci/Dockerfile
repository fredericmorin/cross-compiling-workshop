FROM ubuntu:latest as ci
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y \
# build
        build-essential \
        cmake \
# deps
        libpcap-dev \
    && rm -rf /var/lib/apt/lists/*
SHELL ["/bin/bash", "-c"]
