# The different levels of understanding of cross-compiling for a target platform

Goals:

- compile app natively
  - `build-native-manual.sh`
  - `build-native-cmake.sh`
- compile using docker build env
  - `build-native-with-docker.sh`
- cross compile app
  - `build-aarch64-with-qemu.sh`
  - `build-aarch64-with-cmake.sh`
- cross compile using docker qemu
  - `build-aarch64-with-docker.sh`
- cross compile using toolchain in a docker generated rootfs

## Run

script|target|compiler runtime(1)|first run(2)|after clean(3)|speed
|-|-|-|-|-|-
`build-native-manual.sh`|amd64|host|0.315s|0.307s|0.302s
`build-native-cmake.sh`|amd64|host|0.572s|0.594s|0.033s
`build-native-with-docker.sh`|amd64|host (inside docker)|43.458s|2.239s|1.464s
`build-aarch64-with-cmake.sh`|aarch64|host|31.527s|30.661s|0.040s
`build-aarch64-with-qemu.sh`|aarch64|aarch64 (inside proot)|94.758s|93.816s|2.990s
`build-aarch64-with-docker.sh`|aarch64|aarch64 (inside docker)|173.833s|13.854s|5.226s

1. assumes host to be a amd64 platform
2. after `rm -rf workspace-build* && docker system prune --all --force`
3. after `rm -rf workspace-build*`. typical of a jenkins workspace cleanup

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
