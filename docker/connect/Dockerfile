# https://github.com/confluentinc/kafka-images/blob/master/kafka-connect-base/Dockerfile.deb8
FROM confluentinc/cp-server-connect-base:5.5.0

ENV MYSQL_DRIVER_VERSION 5.1.49
ENV CONNECT_PLUGIN_PATH "/usr/share/java,/connect/plugins,/usr/share/confluent-hub-components"
ENV CONNECT_SPOOLDIR_VER 2.0.43
ENV CONNECT_DATAGEN_VER 0.3.2
ENV CONNECT_JDBC_VER 5.5.0

RUN curl -k -SL \
     "https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_DRIVER_VERSION}.tar.gz" \
     | tar -xzf - -C /usr/share/java/kafka \
     --strip-components=1 \
     mysql-connector-java-${MYSQL_DRIVER_VERSION}/mysql-connector-java-${MYSQL_DRIVER_VERSION}-bin.jar

RUN confluent-hub install --no-prompt confluentinc/kafka-connect-datagen:${CONNECT_DATAGEN_VER}
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-jdbc:${CONNECT_JDBC_VER}
RUN confluent-hub install --no-prompt jcustenborder/kafka-connect-spooldir:${CONNECT_SPOOLDIR_VER}