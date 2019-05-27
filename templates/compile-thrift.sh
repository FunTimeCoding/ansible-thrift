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

gpg2 --verify "${SIGNATURE_FILE}" "${SOURCE_ARCHIVE}"

if [ ! -d "${SOURCE_DIRECTORY}" ]; then
    mkdir "${SOURCE_DIRECTORY}"
    tar --extract --file "${SOURCE_ARCHIVE}" --directory "${SOURCE_DIRECTORY}" --strip-components 1
fi

if [ ! -d "${PREFIX}" ]; then
    cd "${SOURCE_DIRECTORY}"
    export PY_PREFIX="${HOME}/opt/thrift-python-${VERSION}"
    export PHP_PREFIX="${HOME}/opt/thrift-php-${VERSION}"
    ./configure --prefix="${PREFIX}"
    make
    make install
fi

echo "PREFIX: ${PREFIX}"
