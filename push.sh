#!/usr/bin/env bash

set -euo pipefail

img_list=(
    datanode
    hadoop-base
    hadoopclient
    hadoop
    historyserver
    namenode
    nodemanager
    resourcemanager
    securedatanode
)

echo "${CI_PASS}" | docker login -u "${CI_USER}" --password-stdin

for img in "${img_list[@]}"; do
    docker push crs4/${img}:${HADOOP_VERSION}
    if [ -n "${SHORT_TAG:-}" ]; then
	docker tag crs4/${img}:${HADOOP_VERSION} crs4/${img}:${SHORT_TAG}
	docker push crs4/${img}:${SHORT_TAG}
    fi
    if [ -n "${LATEST:-}" ]; then
	docker tag crs4/${img}:${HADOOP_VERSION} crs4/${img}:latest
	docker push crs4/${img}:latest
    fi
done
