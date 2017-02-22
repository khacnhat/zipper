#!/bin/bash
set -e

CONTAINER_NAME=cyber-dojo-zipper-kata-DATA-CONTAINER

docker run --rm -it --volumes-from ${CONTAINER_NAME} --workdir /tmp/katas cyberdojo/ruby sh