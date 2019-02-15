#!/usr/bin/env bash

set -euo pipefail

this="${BASH_SOURCE-$0}"
this_dir=$(cd -P -- "$(dirname -- "${this}")" && pwd -P)
tar="${this_dir}/hadoop-${hadoop_version}.tar.gz"

mkdir -p "${hadoop_home}"
tar xf "${tar}" --strip 1 -C "${hadoop_home}"
major_version=${hadoop_version%%.*}
from_conf="${this_dir}/conf/hadoop${major_version}"
to_conf="${hadoop_home}/etc/hadoop"
cp -f "${from_conf}"/* "${to_conf}"/
for name in hadoop mapred yarn; do
    sed -i "1iexport JAVA_HOME=${JAVA_HOME}" "${to_conf}/${name}-env.sh"
done
