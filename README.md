# hadoop-docker
Docker images for Apache Hadoop

```
$ docker build -t test_hadoop -f Dockerfile.ubuntu .
$ export PORT_FW="-p 8020:8020 -p 8042:8042 -p 8088:8088 -p 9000:9000 -p 10020:10020 -p 19888:19888 -p 9866:9866 -p 9867:9867 -p 9870:9870 -p 9864:9864 -p 9868:9868"
$ docker run --name hadoop ${PORT_FW} -d test_hadoop
$ docker exec -it hadoop bash -l
$ hdfs dfs -mkdir -p "/user/$(whoami)"
$ hdfs dfs -put entrypoint.sh
$ export V=$(hadoop version | head -n 1 | awk '{print $2}')
$ hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-${V}.jar wordcount entrypoint.sh wc_out
[...]
$ hdfs dfs -get wc_out
$ grep hadoop wc_out/part*
```

## Changing the Hadoop version

```
docker build --build-arg hadoop_version=2.9.2 ...
```

Note that ports are different in Hadoop 2:

```
export PORT_FW="-p 8020:8020 -p 8042:8042 -p 8088:8088 -p 9000:9000 -p 10020:10020 -p 19888:19888 -p 50010:50010 -p 50020:50020 -p 50070:50070 -p 50075:50075 -p 50090:50090"
```

## Custom configuration

Images come with a simple default configuration (in `/opt/hadoop/etc/hadoop`)
that should be good enough for a test cluster. If the `HADOOP_CUSTOM_CONF_DIR`
environment variable is set to the path of directory visible by the container,
the entrypoint links any files found there into the Hadoop configuration
directory, forcing a replacement if necessary. For instance, to use a custom
`hdfs-site.xml`, you can save it to a `/tmp/hadoop` directory and run the
container as follows:

```
docker run ${PORT_FW} -v /tmp/hadoop:/hadoop_custom_conf -e HADOOP_CUSTOM_CONF_DIR=/hadoop_custom_conf -d test_hadoop
```

Another way to customize the configuration is to override the entire directory
with a bind mount. For instance, to change the HDFS block size:

```
# Copy the default config to /tmp/hadoop
docker run --rm --entrypoint /bin/bash test_hadoop -c "tar -c -C /opt/hadoop/etc hadoop" | tar -x -C /tmp
# Add a property
$ sed -i "s|</configuration>|<property><name>dfs.blocksize</name><value>$((256*2**20))</value></property></configuration>|" /tmp/hadoop/hdfs-site.xml
# Run the container, overriding the configuration directory
$ docker run ${PORT_FW} -v /tmp/hadoop:/opt/hadoop/etc/hadoop -d test_hadoop
```

## Automatic hostname setting

The entrypoint automatically replaces "localhost", if found in the value of
the `fs.defaultFS` property, with the running container's hostname (this
allows to contact the name node from outside the container). Since this
substitution happens before HADOOP_CUSTOM_CONF_DIR is processed, it has no
effect if `${HADOOP_CUSTOM_CONF_DIR}/core-site.xml` is provided. Bind mounts,
however, take effect before the entrypoint is executed, so use one or the
other configuration method depending on whether you want the automatic
hostname setting to take place or not.
