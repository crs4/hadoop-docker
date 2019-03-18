#!/bin/bash

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

hdfs datanode
