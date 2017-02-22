#!/bin/bash
set -e

my_dir="$( cd "$( dirname "${0}" )" && pwd )"

${my_dir}/server/katas/create_data_container.sh
${my_dir}/server/katas/fill_data_container.sh

${my_dir}/build.sh
${my_dir}/up.sh
${my_dir}/test.sh ${*}