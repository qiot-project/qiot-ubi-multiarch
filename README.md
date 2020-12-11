![Build](https://github.com/qiot-project/qiot-ubi-multiarch/workflows/CI/badge.svg?branch=main)


# qiot-ubi-multiarch
A project to create a multiarch UBI image that supports running different architecture containers on x86_64 hosts


## Building

```
./build.sh -a aarch64 -c qiot-ubi-multiarch -v 1.0 -q v5.1.0-7
```