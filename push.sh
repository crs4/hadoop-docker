#!/usr/bin/env bash

set -euo pipefail

cmd_list=(
    datanode
    hadoop-base
    hadoopclient
    hadoop
    historyserver
    namenode
    nodemanager
    resourcemanager
)
[ "${OS}" == "ubuntu" ] && cmd_list+=( securedatanode )

echo "${CI_PASS}" | docker login -u "${CI_USER}" --password-stdin

for cmd in "${cmd_list[@]}"; do
    docker push crs4/${cmd}:${HADOOP_VERSION}-${OS}
    if [ -n "${SHORT_TAG:-}" ]; then
	docker tag crs4/${cmd}:${HADOOP_VERSION}-${OS} crs4/${cmd}:${SHORT_TAG}
	docker push crs4/${cmd}:${SHORT_TAG}
    fi
    if [ -n "${LATEST:-}" ]; then
	docker tag crs4/${cmd}:${HADOOP_VERSION}-${OS} crs4/${cmd}:latest
	docker push crs4/${cmd}:latest
    fi
done
