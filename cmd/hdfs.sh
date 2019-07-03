#!/bin/bash

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

function onshutdown {
    hadoop-daemon.sh stop datanode
    hadoop-daemon.sh stop namenode
}

trap onshutdown SIGTERM
trap onshutdown SIGINT

nn_dir=$(hdfs getconf -confKey dfs.namenode.name.dir | sed 's|^file:||')
[ -d "${nn_dir}"/current ] || hdfs namenode -format -force
hadoop-daemon.sh start namenode
hadoop-daemon.sh start datanode
timeout 10 bash -c -- 'hdfs dfsadmin -safemode wait' || \
    hdfs dfsadmin -safemode leave

tail -f /dev/null

onshutdown
