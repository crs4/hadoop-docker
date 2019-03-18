#!/bin/bash

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

nn_dir=$(hdfs getconf -confKey dfs.namenode.name.dir | sed 's|^file:||')
[ -d "${nn_dir}"/current ] || hdfs namenode -format -force
hdfs namenode
