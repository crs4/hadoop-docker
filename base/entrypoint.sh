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
    if [ -e "${HADOOP_CUSTOM_CONF_DIR}/shellprofile.d" ]; then
	rm -rf "${conf_dir}/shellprofile.d"
    fi
    find "${HADOOP_CUSTOM_CONF_DIR}" -mindepth 1 -maxdepth 1 -exec \
      ln -sfn {} "${conf_dir}"/ \;
fi

exec $@
