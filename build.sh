#!/usr/bin/env bash

set -euo pipefail

docker build \
  --build-arg hadoop_version=${HADOOP_VERSION} \
  -f base/Dockerfile.${OS} \
  -t crs4/hadoop-base:${HADOOP_VERSION}-${OS} base

for cmd in hadoop; do
    docker build \
      --build-arg cmd=${cmd} \
      --build-arg hadoop_version=${HADOOP_VERSION} \
      --build-arg os=${OS} \
      -t crs4/${cmd}:${HADOOP_VERSION}-${OS} .
done
