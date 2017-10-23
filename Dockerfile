FROM ubuntu:latest

MAINTAINER AxlDlv

ENV TOMCAT_VERSION 9.0.1
ENV TOMCAT_VERSION_MIN 9

# Fix sh
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install dependencies
RUN apt-get update
RUN apt-get install -y git build-essential curl wget software-properties-common

# Install JDK 8
RUN \
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
add-apt-repository -y ppa:webupd8team/java && \
apt-get update && \
apt-get install -y oracle-java8-installer wget unzip tar && \
rm -rf /var/lib/apt/lists/* && \
rm -rf /var/cache/oracle-jdk8-installer

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Get Tomcat
RUN apt-get install -y bzip2
RUN wget --no-cookies http://www-us.apache.org/dist/tomcat/tomcat-${TOMCAT_VERSION_MIN}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/tomcat.tgz && \
tar -xzvf /tmp/tomcat.tgz -C /opt && mv /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat

# Remove garbage
RUN rm /tmp/tomcat.tgz && rm -rf /opt/tomcat/webapps/examples && rm -rf /opt/tomcat/webapps/docs && rm -rf /opt/tomcat/webapps/ROOT

# copy the WAR bundle to tomcat
COPY /target/SpringApp.war /opt/tomcat/webapps/app.war

ENV CATALINA_HOME /opt/tomcat
ENV PATH $PATH:$CATALINA_HOME/bin

EXPOSE 8080
EXPOSE 8009
EXPOSE 4110
#VOLUME "/opt/tomcat/webapps"
WORKDIR /opt/tomcat

CMD ["catalina.sh", "run"]