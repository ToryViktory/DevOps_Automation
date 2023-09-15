# Set default versions of base images
ARG jdk_version=11
ARG mvn_version=3

############### BUILD STAGE ###############
# Download maven:3-openjdk-11 from dockerhub
FROM maven:${mvn_version}-openjdk-${jdk_version} AS BUILD

# Update image
RUN apt-get update

# Set working directory for container 
WORKDIR /app

# Copy maven dependency packages and sorces
COPY src /app/src
COPY pom.xml /app

# Download all dependencies
RUN mvn -f /app/pom.xml clean package

############### PACKAGE STAGE ###############
FROM openjdk:${jdk_version}-jre-slim as PACKAGE
ARG JAR_NAME
ENV APP_NAME=${JAR_NAME}
WORKDIR /app

COPY --from=BUILD /app/target/${APP_NAME} ./main.jar
EXPOSE 8080
ENTRYPOINT [ "java", "-jar", "main.jar" ]