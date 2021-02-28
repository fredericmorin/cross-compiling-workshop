# The different levels of understanding of cross-compiling for a target platform

Goals:

- compile app natively
  - `build-native-manual.sh`
  - `build-native-cmake.sh`
- compile using docker build env
- cross compile using docker qemu
- cross compile using toolchain
- cross compile using toolchain in a docker generated rootfs

## CI

To validate all examples:
```sh
./scripts/ci/shell.sh ./scripts/build.sh --clean
```
