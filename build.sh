#!/usr/bin/env bash

set -euo pipefail

cmd_list=(
    datanode
    hadoopclient
    hadoop
    hdfs
    historyserver
    namenode
    nodemanager
    resourcemanager
)

docker build \
  --build-arg hadoop_version=${HADOOP_VERSION} \
  -f base/Dockerfile \
  -t crs4/hadoop-base:${HADOOP_VERSION} base

for cmd in "${cmd_list[@]}"; do
    docker build \
      --build-arg cmd=${cmd} \
      --build-arg hadoop_version=${HADOOP_VERSION} \
      -t crs4/${cmd}:${HADOOP_VERSION} .
done

docker build \
  -f Dockerfile.secdn \
  --build-arg hadoop_version=${HADOOP_VERSION} \
  -t crs4/securedatanode:${HADOOP_VERSION} .
