#!/usr/bin/env bash

set -euo pipefail

echo "${CI_PASS}" | docker login -u "${CI_USER}" --password-stdin
docker push crs4/hadoop:${HADOOP_VERSION}-${OS}

if [ -n "${SHORT_TAG:-}" ]; then
    docker tag crs4/hadoop:${HADOOP_VERSION}-${OS} crs4/hadoop:${SHORT_TAG}
    docker push crs4/hadoop:${SHORT_TAG}
fi

if [ -n "${LATEST:-}" ]; then
    docker tag crs4/hadoop:${HADOOP_VERSION}-${OS} crs4/hadoop:latest
    docker push crs4/hadoop:latest
fi
