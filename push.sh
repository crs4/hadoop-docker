#!/usr/bin/env bash

set -euo pipefail

echo "${CI_PASS}" | docker login -u "${CI_USER}" --password-stdin

for cmd in hadoop; do
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
