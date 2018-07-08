#!/bin/bash
set -e

# Note that the --host is needed for IPv4 and IPv6 addresses

bundle exec rackup \
  --warn \
  --host 0.0.0.0 \
  --port ${ZIPPER_SERVICE_PORT} \
  --server thin \
  --env production \
    config.ru
