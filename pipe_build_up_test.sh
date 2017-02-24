#!/bin/bash
set -e

# Using boot2docker the VM's date-time can drift from the
# host's date-time. This affects the date displayed on eg,
# coverage stats.
#
#docker-machine ssh default "sudo date -u $(date -u +%m%d%H%M%Y)"

my_dir="$( cd "$( dirname "${0}" )" && pwd )"

${my_dir}/build.sh
${my_dir}/up.sh
${my_dir}/test.sh ${*}