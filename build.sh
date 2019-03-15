#!/usr/bin/env bash

set -euo pipefail

docker_build() {
    local hv=$1 os=$2 img=$3
    docker build \
      --build-arg hadoop_version=${hv} \
      -t ${img}:${hv}-${os} \
      -f Dockerfile.${os} .
}

docker_build ${HADOOP_VERSION} ${OS} crs4/hadoop-base
for d in hadoop; do
    pushd "${d}"
    docker_build ${HADOOP_VERSION} ${OS} crs4/"${d}"
    popd
done
