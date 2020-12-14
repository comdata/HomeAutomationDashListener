####
# This Dockerfile is used in order to build a container that runs the Quarkus application in JVM mode
#
# Before building the docker image run:
#
# mvn package
#
# Then, build the image with:
#
# docker build -f src/main/docker/Dockerfile.jvm -t quarkus/getting-started-jvm .
#
# Then run the container using:
#
# docker run -i --rm -p 8080:8080 quarkus/getting-started-jvm
#
###

FROM ghcr.io/comdata/docker-image:latest
ENV JAVA_OPTIONS="-Dquarkus.http.host=0.0.0.0 -Djava.util.logging.manager=org.jboss.logmanager.LogManager"
ENV AB_ENABLED=jmx_exporter

RUN mkdir /source
RUN mkdir /source/.mvn/wrapper/


COPY * /source/
COPY .mvn/wrapper/maven-wrapper.properties /source/.mvn/wrapper/maven-wrapper.properties
WORKDIR /source
RUN ./mvnw package -Pnative -Dquarkus.native.container-build=true
RUN cp target/*-runner /runner

ENTRYPOINT ["sh", "-c", "/runner" ]

