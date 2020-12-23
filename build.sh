#!/bin/bash -xe

function usage() {
    echo "Usage: ./build.sh -a [architecture eg. aarch64] -c [container name] -v [container version] -q [qemu version]"
    exit 1
}

# A POSIX variable
OPTIND=1 # Reset in case getopts has been used previously in the shell.

while getopts "a:c:v:q:" opt; do
    case "$opt" in
    a)  ARCH=$OPTARG
        ;;
    c)  CONTAINER=$OPTARG
        ;;
    v)  VERSION=$OPTARG
        ;;
    q)  QEMU_VER=$OPTARG
        ;;
    esac
done

if [ -z "${ARCH}" ] || [ -z "${CONTAINER}" ] || [ -z "${VERSION}" ] || [ -z "${QEMU_VER}" ]; then
    usage
fi

wget_common_opts="-t 3 -w 1 --retry-connrefused --no-dns-cache --retry-on-http-error=403"
wget_opts="${wget_common_opts} -N"

function wget_and_sleep() {
    wget ${@}
    return_code=${?}
    sleep 1
    return ${return_code}
}

cat > Dockerfile <<EOF
FROM registry.access.redhat.com/ubi8/ubi
EOF

if [ -n "${ARCH}" ]; then
    if [ ! -f x86_64_qemu-${QARCHEMU_ARCH}-static.tar.gz ]; then
        wget_and_sleep ${wget_opts} https://github.com/multiarch/qemu-user-static/releases/download/${QEMU_VER}/x86_64_qemu-${ARCH}-static.tar.gz
    fi
    cat >> Dockerfile <<EOF
# Add qemu-user-static binary for x86_64 builders
ADD x86_64_qemu-${ARCH}-static.tar.gz /usr/bin
EOF
fi

cat >> Dockerfile <<EOF
# overwrite this with 'CMD []' in a dependent Dockerfile
CMD ["/bin/bash"]
EOF

docker build -t "${CONTAINER}:${VERSION}" --platform ${ARCH} --pull .

docker run -i --rm "${CONTAINER}:${VERSION}" bash -xc '
    uname -a
    echo
    cat /etc/os-release 2>/dev/null
'
