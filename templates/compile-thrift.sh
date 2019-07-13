#!/bin/sh -e

VERSION="${1}"

if [ "${VERSION}" = '' ]; then
    echo "Usage: ${0} VERSION"

    exit 1
fi

SOURCE_BASE_DIRECTORY="${HOME}/src"
NAME="thrift-${VERSION}"

FILE="${NAME}.tar.gz"
SIGNATURE_FILE="${SOURCE_BASE_DIRECTORY}/${FILE}.asc"
SOURCE_ARCHIVE="${SOURCE_BASE_DIRECTORY}/${FILE}"
SOURCE_DIRECTORY="${SOURCE_BASE_DIRECTORY}/${NAME}"
PREFIX="${HOME}/opt/${NAME}"

if [ ! -f "${SOURCE_ARCHIVE}" ]; then
    mkdir -p "${SOURCE_BASE_DIRECTORY}"
    wget --quiet --output-document "${SOURCE_ARCHIVE}" "http://apache.lauf-forum.at/thrift/${VERSION}/${FILE}"
fi

if [ ! -f "${SIGNATURE_FILE}" ]; then
    wget --quiet --output-document "${SIGNATURE_FILE}" "https://www.apache.org/dist/thrift/${VERSION}/${FILE}.asc"
fi

gpg --keyserver keyserver.ubuntu.com --recv 9348F0369A20818400F87140C6F2B11BEDD02683
gpg --verify "${SIGNATURE_FILE}" "${SOURCE_ARCHIVE}"

if [ ! -d "${SOURCE_DIRECTORY}" ]; then
    mkdir "${SOURCE_DIRECTORY}"
    tar --extract --file "${SOURCE_ARCHIVE}" --directory "${SOURCE_DIRECTORY}" --strip-components 1
fi

if [ ! -d "${PREFIX}" ]; then
    cd "${SOURCE_DIRECTORY}"
    export PY_PREFIX="${HOME}/opt/thrift-python-${VERSION}"
    export PHP_PREFIX="${HOME}/opt/thrift-php-${VERSION}"
    # Skip Ruby since it would try to use sudo to bundle install system wide.
    # TODO: Maybe it can be configured to use bundle in user mode.
    #./configure --without-ruby --prefix="${PREFIX}"
    # Skip even more to minimize problem sources that are not required.
    ./configure --without-ruby --without-java --without-perl --without-erlang --without-csharp --without-haskell --without-cpp --without-haxe --without-lua --without-nodejs --without-dotnetcore --without-dlang --without-dart --without-python --without-go --prefix="${PREFIX}"
    make
    make install
fi

echo "PREFIX: ${PREFIX}"
