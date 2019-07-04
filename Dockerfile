ARG cmd=hadoop
ARG hadoop_version=3.2.0

FROM crs4/hadoop-base:${hadoop_version}
ARG cmd
COPY cmd/${cmd}.sh /cmd.sh

CMD ["/cmd.sh"]
