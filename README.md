![Build](https://github.com/qiot-project/qiot-ubi-multiarch/workflows/CI/badge.svg?branch=main)


# qiot-ubi-multiarch
A project to create a multiarch UBI image that supports running different architecture containers on x86_64 hosts. This makes use of the https://github.com/multiarch/qemu-user-static project to allow emulation for non-native container images.


## Building

Configure docker to be able to run multiarch containers (the build script outputs details from the built container). This is not required when using docker for mac as the build environment.
```
docker run --rm --privileged multiarch/qemu-user-static:register --reset
```

Next, run the build script:

Parameters:
-a [target architecture]
-c [docker repo/container name]
-v [image tag]
-q [qemu static version (https://github.com/multiarch/qemu-user-static/releases)]

```
./build.sh -a aarch64 -c qiot-ubi-multiarch -v 1.0 -q v5.1.0-7
```

## Releases

Releases are published to Quay.io (https://quay.io/repository/qiotproject/ubi-multiarch)
