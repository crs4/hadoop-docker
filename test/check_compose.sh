#!/bin/bash

set -euo pipefail

this="${BASH_SOURCE-$0}"
this_dir=$(cd -P -- "$(dirname -- "${this}")" && pwd -P)

pushd "${this_dir}/.."
cid=$(docker-compose ps -q client)
if [ -z "${cid:-}" ]; then
    echo 'ERROR: service "client" is not running' 1>&2
    exit 1
fi
docker-compose exec datanode bash -c 'until datanode_cid; do sleep 0.1; done'
docker cp "${this_dir}/check.sh" ${cid}:/
docker-compose exec client bash /check.sh
popd
