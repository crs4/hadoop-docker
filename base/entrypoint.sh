#!/bin/bash

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

conf_dir=$(dirname $(dirname $(command -v hadoop)))/etc/hadoop

# Hadoop shell scripts assume USER is defined
export USER="${USER:-$(whoami)}"

# allow HDFS access from outside the container
nn_host=${NAMENODE_HOSTNAME:-${HOSTNAME}}
sed -i s/localhost/${nn_host}/ "${conf_dir}"/core-site.xml

if [ -d "${HADOOP_CUSTOM_CONF_DIR:-}" ]; then
    find "${HADOOP_CUSTOM_CONF_DIR}" -maxdepth 1 -type f -exec \
      ln -sfn {} "${conf_dir}"/ \;
fi

exec $@
