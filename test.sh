#!/bin/bash

my_dir="$( cd "$( dirname "${0}" )" && pwd )"
my_name="${my_dir##*/}"

server_cid=`docker ps --all --quiet --filter "name=${my_name}_server"`
server_status=0

# - - - - - - - - - - - - - - - - - - - - - - - - - -

run_server_tests()
{
  docker exec ${server_cid} sh -c "cd test && ./run.sh ${*}"
  server_status=$?
  docker cp ${server_cid}:/tmp/coverage ${my_dir}/server
  echo "Coverage report copied to ${my_dir}/server/coverage"
  cat ${my_dir}/server/coverage/done.txt
}

# - - - - - - - - - - - - - - - - - - - - - - - - - -

run_server_tests ${*}

if [[ ( ${server_status} == 0 ) ]];  then
  docker-compose down
  echo "------------------------------------------------------"
  echo "All passed"
  exit 0
else
  echo
  echo "server: cid = ${server_cid}, status = ${server_status}"
  if [ "${server_cid}" != "0" ]; then
    docker logs ${my_name}_server
  fi
  echo
  exit 1
fi

