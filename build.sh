#!/usr/bin/env bash

set -euo pipefail

cmd_list=(
    datanode
    hadoopclient
    hadoop
    historyserver
    namenode
    nodemanager
    resourcemanager
)

docker build \
  --build-arg hadoop_version=${HADOOP_VERSION} \
  -f base/Dockerfile.${OS} \
  -t crs4/hadoop-base:${HADOOP_VERSION}-${OS} base

for cmd in "${cmd_list[@]}"; do
    docker build \
      --build-arg cmd=${cmd} \
      --build-arg hadoop_version=${HADOOP_VERSION} \
      --build-arg os=${OS} \
      -t crs4/${cmd}:${HADOOP_VERSION}-${OS} .
done
