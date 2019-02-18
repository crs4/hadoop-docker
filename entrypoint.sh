#!/bin/bash

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

function onshutdown {
    mr-jobhistory-daemon.sh stop historyserver
    yarn-daemon.sh stop nodemanager
    yarn-daemon.sh stop resourcemanager
    hadoop-daemon.sh stop datanode
    hadoop-daemon.sh stop namenode
}

trap onshutdown SIGTERM
trap onshutdown SIGINT

# Hadoop shell scripts assume USER is defined
export USER="${USER:-$(whoami)}"

# allow HDFS access from outside the container
conf_dir=$(type -p hadoop | sed 's/bin/etc/')
sed -i s/localhost/${HOSTNAME}/ "${conf_dir}"/core-site.xml

hadoop namenode -format -force
hadoop-daemon.sh start namenode
hadoop-daemon.sh start datanode
timeout 10 bash -c -- 'hdfs dfsadmin -safemode wait' || \
    hdfs dfsadmin -safemode leave
yarn-daemon.sh start resourcemanager
yarn-daemon.sh start nodemanager
mr-jobhistory-daemon.sh start historyserver

tail -f /dev/null

onshutdown
