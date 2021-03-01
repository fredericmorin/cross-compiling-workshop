# The different levels of understanding of cross-compiling for a target platform

Goals:

- compile app natively
  - `build-native-manual.sh`
  - `build-native-cmake.sh`
- compile using docker build env
  - `build-native-with-docker.sh`
- cross compile using docker qemu
- cross compile using toolchain
- cross compile using toolchain in a docker generated rootfs

## Run

script|target|compiler runtime*|
|-|-|-
`build-native-manual.sh` and `build-native-cmake.sh` |amd64|host amd64|
`build-native-with-docker.sh`|amd64|docker amd64|

(*) assumes host to be a amd64 platform:

## The App

Just a simple c++ pcap packet counter application.

```
Usage: app <pcapfile>
 pcapfile     pcap capture file with imu and lidar udp traffic
```

## Deps

### Docker 19.03+

Docker version 19.03 or more recent is required to run CPU emulated container using buildx.

See https://docs.docker.com/engine/install/ for installation instructions

## Run all

```sh
./scripts/build-all.sh --clean
```

## CI

To emulate a jenkins CI build environment locally prepend your command with `./scripts/ci/shell.sh`.

```sh
./scripts/ci/shell.sh ./scripts/build-all.sh --clean
```
