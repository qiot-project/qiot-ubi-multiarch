ARG UBI_VERSION=8.6
ARG ARCH=aarch64
ARG QEMU_STATIC_TARBALL
FROM registry.access.redhat.com/ubi8/ubi:$UBI_VERSION
LABEL "architecture"=$ARCH
LABEL "multiarch"="true"
# Add qemu-user-static binary for x86_64 builders
ADD $QEMU_STATIC_TARBALL /usr/bin
# overwrite this with 'CMD []' in a dependent Dockerfile
RUN dnf -y upgrade && dnf clean all
CMD ["/bin/bash"]
