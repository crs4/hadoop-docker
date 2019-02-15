#!/usr/bin/env bash

set -euo pipefail

export USER="${USER:-$(whoami)}"

wd=$(mktemp -d)
pushd ${wd}

cat >input <<EOF
the quick fox
jumped over
the lazy fox
EOF

hdfs dfs -mkdir -p "/user/${USER}"
hdfs dfs -put input
version=$(hadoop version | head -n 1 | awk '{print $2}')
hadoop_share=$(type -p hadoop | sed 's/bin/share/')
jar="${hadoop_share}/mapreduce/hadoop-mapreduce-examples-${version}.jar"
hadoop jar "${jar}" wordcount input output
hdfs dfs -cat output/part* | sort >output

cat >exp_output <<EOF
fox	2
jumped	1
lazy	1
over	1
quick	1
the	2
EOF

cmp output exp_output

popd
rm -rf "${wd}"
