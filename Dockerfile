ARG cmd=hadoop
ARG hadoop_version=3.2.0
ARG os=ubuntu

FROM crs4/hadoop-base:${hadoop_version}-${os}
ARG cmd
COPY cmd/${cmd}.sh /cmd.sh

CMD ["/cmd.sh"]
