#!/usr/bin/env bash

set -euo pipefail

this="${BASH_SOURCE-$0}"
this_dir=$(cd -P -- "$(dirname -- "${this}")" && pwd -P)
repo="http://www-eu.apache.org/dist/hadoop/common"
tar="hadoop-${hadoop_version}.tar.gz"

mkdir -p "${hadoop_home}"
echo "getting ${repo}/hadoop-${hadoop_version}/${tar}"
wget -q -O - "${repo}/hadoop-${hadoop_version}/${tar}" | \
    tar xz --strip 1 -C "${hadoop_home}"
major_version=${hadoop_version%%.*}
from_conf="${this_dir}/conf/hadoop${major_version}"
to_conf="${hadoop_home}/etc/hadoop"
cp -f "${from_conf}"/* "${to_conf}"/
for name in hadoop mapred yarn; do
    sed -i "1iexport JAVA_HOME=${JAVA_HOME}" "${to_conf}/${name}-env.sh"
done

if [ -n "${native_libs_dir:-}" ]; then
    echo "copying native libs from ${native_libs_dir}"
    rm -rf "${hadoop_home}"/lib/native/*
    mv "${native_libs_dir}"/* "${hadoop_home}"/lib/native/
    rm -rf "${native_libs_dir}"
fi

rm -rf "${hadoop_home}"/share/doc
