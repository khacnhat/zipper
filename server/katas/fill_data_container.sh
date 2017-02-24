#!/bin/bash
set -e

# called from pipe_build_up_test.sh

MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

. ${MY_DIR}/../../.env

for ID in DA F6 1D 69 7A
do
  docker cp \
    ${MY_DIR}/${ID} \
    ${CYBER_DOJO_ZIPPER_KATA_DATA_CONTAINER}:${CYBER_DOJO_KATAS_ROOT}/${ID}
done
