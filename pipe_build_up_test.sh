#!/bin/bash
set -e

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
readonly MY_NAME="${MY_DIR##*/}"
readonly SH_DIR="${MY_DIR}/sh"

"${SH_DIR}/build_docker_images.sh"
"${SH_DIR}/docker_containers_up.sh"
if "${SH_DIR}/run_tests_in_containers.sh" "$@"; then
  "${SH_DIR}/docker_containers_down.sh"
  docker rmi "cyberdojo/${MY_NAME}-client" &> /dev/null
  docker image prune --force
fi
