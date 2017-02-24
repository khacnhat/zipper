#!/bin/bash
set -e

MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

. ${MY_DIR}/../../.env

docker run --rm -it \
  --volumes-from ${CYBER_DOJO_ZIPPER_KATA_DATA_CONTAINER} \
  --workdir ${CYBER_DOJO_KATAS_ROOT} \
  cyberdojo/ruby sh