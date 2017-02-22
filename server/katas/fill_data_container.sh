#!/bin/bash
set -e

# called from pipe_build_up_test.sh

MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

CYBER_DOJO_ZIPPER_KATA_ROOT=/tmp/katas
CYBER_DOJO_ZIPPER_KATA_DATA_CONTAINER=cyber-dojo-zipper-kata-DATA-CONTAINER

cd ${MY_DIR}

for ID in DA F6 1D 69 7A
do
  docker cp \
    ${MY_DIR}/${ID} \
    ${CYBER_DOJO_ZIPPER_KATA_DATA_CONTAINER}:${CYBER_DOJO_ZIPPER_KATA_ROOT}/${ID}
done

# can't exec directly into zipper-kata-data-container as it is not running
# so use cyberdojo/ruby image

docker run \
  --rm \
  --tty \
  --volumes-from ${CYBER_DOJO_ZIPPER_KATA_DATA_CONTAINER} \
  cyberdojo/ruby:latest \
  sh -c "chown -R cyber-dojo:cyber-dojo /tmp/katas"

