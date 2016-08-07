# This Dockerfile is not awesome.
# Use it as a starting point for your own Jira image.
FROM centos:7.2.1511

RUN mkdir -p /opt/
RUN mkdir /opt/jira-home

# Host atlassian-jira-software-7.1.9.tar.gz somewhere you download from.
# Download the tar archive from https://www.atlassian.com/software/jira/download.
RUN curl -O https://example.com/atlassian-jira-software-7.1.9.tar.gz

# Host jdk-8u101-linux-x64.tar.gz somewhere you download from.
# Download the tar archive from http://www.oracle.com/technetwork/java/javase/downloads/index.html.
RUN curl -R -O https://example.com/jdk-8u101-linux-x64.tar.gz

RUN tar -xvf jdk-8u101-linux-x64.tar.gz
RUN mv jdk1.8.0_101 /opt/

RUN tar -xvf atlassian-jira-software-7.1.9.tar.gz
RUN mv atlassian-jira-software-7.1.9-standalone /opt

ENV JAVA_HOME="/opt/jdk1.8.0_101"
ENV JIRA_HOME="/opt/jira-home"

RUN echo 'jira.home = /opt/jira-home' > \
  /opt/atlassian-jira-software-7.1.9-standalone/atlassian-jira/WEB-INF/classes/jira-application.properties

ENTRYPOINT ["/opt/atlassian-jira-software-7.1.9-standalone/bin/catalina.sh", "run"]
