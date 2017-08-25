#!/bin/bash
set -e

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"

docker-compose --file ${ROOT_DIR}/docker-compose.yml down --volumes
docker-compose --file ${ROOT_DIR}/docker-compose.yml up -d

sleep 1

check_up()
{
  set +e
  local s=$(docker ps --filter status=running --format '{{.Names}}' | grep ^${1}$)
  set -e
  if [ "${s}" != "${1}" ]; then
    echo
    echo "${1} exited"
    docker logs ${1}
    exit 1
  fi
}

check_up 'zipper_server'
check_up 'zipper_client'
check_up 'storer_server'
