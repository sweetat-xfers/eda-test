FROM openjdk:8-alpine

ENV VERSION 2.1.5
WORKDIR /kafka-monitor-${VERSION}

RUN apk add --update-cache \
    bash \
    curl \
    git \
  && git clone --single-branch --branch ${VERSION} \
    https://github.com/linkedin/kafka-monitor.git \
    /kafka-monitor-${VERSION} \
  && ./gradlew jar \
  && chmod 755 /kafka-monitor-${VERSION}/bin/*.sh

CMD ["/kafka-monitor-${VERSION}/bin/kafka-monitor-start.sh /kafka-monitor-${VERSION}/config/kafka-monitor.properties"]
