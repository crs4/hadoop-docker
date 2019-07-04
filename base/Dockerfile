ARG hadoop_home=/opt/hadoop
ARG hadoop_version=3.2.0
ARG java_version=8

FROM crs4/hadoop-nativelibs:${hadoop_version}-ubuntu AS install-hadoop
ARG hadoop_home
ARG hadoop_version
ARG java_version
COPY resources /resources
RUN apt-get -y update && apt-get -y install wget \
    && native_libs_dir=/hadoop_native JAVA_HOME=/usr/lib/jvm/java-${java_version}-openjdk-amd64 bash /resources/install_hadoop.sh

# Java System.loadLibrary ignores ld.so.conf, so we also set LD_LIBRARY_PATH
FROM ubuntu:18.04
ARG hadoop_home
ARG java_version
COPY --from=install-hadoop "${hadoop_home}" "${hadoop_home}"
COPY entrypoint.sh /
RUN apt-get -y update && apt-get -y install --no-install-recommends \
      openjdk-${java_version}-jre-headless \
      wget \
    && apt-get clean && rm -rf /var/lib/apt-lists/* /tmp/* /var/tmp/* \
    && echo "export LD_LIBRARY_PATH=\"${hadoop_home}/lib/native:\${LD_LIBRARY_PATH}\"" >>/etc/profile.d/hadoop.sh \
    && echo "export PATH=\"${hadoop_home}/bin:${hadoop_home}/sbin:\${PATH}\"" >>/etc/profile.d/hadoop.sh \
    && echo "${hadoop_home}/lib/native" > /etc/ld.so.conf.d/hadoop.conf \
    && ldconfig
ENV JAVA_HOME=/usr/lib/jvm/java-${java_version}-openjdk-amd64
ENV LD_LIBRARY_PATH="${hadoop_home}/lib/native:${LD_LIBRARY_PATH}"
ENV PATH="${hadoop_home}/bin:${hadoop_home}/sbin:${PATH}"
ENTRYPOINT ["/entrypoint.sh"]
