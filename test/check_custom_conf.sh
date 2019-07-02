#!/usr/bin/env bash

set -euo pipefail

die() {
    echo $1 1>&2
    exit 1
}

img=crs4/hadoop-base:${HADOOP_VERSION}
new_bs=$((16*2**20))
foo_content="export FOO=foo"

wd=$(mktemp -d)
mkdir -p "${wd}"/{data,hadoop}
cp base/resources/conf/hadoop3/hdfs-site.xml "${wd}"/data/
docker run --rm ${img} cat /opt/hadoop/etc/hadoop/hdfs-site.xml >"${wd}"/data/hdfs-site.xml
sed -i "s|</configuration>|<property><name>dfs.blocksize</name><value>${new_bs}</value></property></configuration>|" "${wd}"/data/hdfs-site.xml
ln -s ../data/hdfs-site.xml "${wd}"/hadoop/
mkdir "${wd}"/hadoop/shellprofile.d
echo "${foo_content}" >"${wd}"/hadoop/shellprofile.d/foo.sh
bs=$(docker run --rm -v "${wd}":"${wd}":ro -e HADOOP_CUSTOM_CONF_DIR="${wd}"/hadoop ${img} hdfs getconf -confKey dfs.blocksize)
[ ${bs} -eq ${new_bs} ] || die "failed to set custom blocksize"
content=$(docker run --rm -v "${wd}":"${wd}":ro -e HADOOP_CUSTOM_CONF_DIR="${wd}"/hadoop ${img} cat /opt/hadoop/etc/hadoop/shellprofile.d/foo.sh)
[ "${content}" == "${foo_content}" ] || die "failed to customize profile"
rm -rf "${wd}"
