#!/bin/bash
set -e

# called from pipe_build_up_test.sh

MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

. ${MY_DIR}/../../.env

name="${CYBER_DOJO_ZIPPER_KATA_DATA_CONTAINER}"
if [ "$(docker ps --all --quiet --filter name=${name})" != "" ]; then
  docker rm --force --volumes ${name}
fi

cd ${MY_DIR}
CONTEXT_DIR=${MY_DIR}
TAG=cyberdojo/zipper_kata

docker build \
  --build-arg=CYBER_DOJO_KATAS_ROOT=${CYBER_DOJO_KATAS_ROOT} \
  --tag=${TAG} \
  --file=Dockerfile \
  ${CONTEXT_DIR}

docker create \
  --name ${CYBER_DOJO_ZIPPER_KATA_DATA_CONTAINER} \
  ${TAG} \
  echo 'cdfZipperKataDC' > /dev/null
