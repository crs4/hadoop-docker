#!/usr/bin/env bash

set -euo pipefail

echo "${CI_PASS}" | docker login -u "${CI_USER}" --password-stdin
docker push crs4/hadoop:${HADOOP_VERSION}-${OS}
