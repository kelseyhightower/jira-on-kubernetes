FROM centos:7.2.1511

RUN mkdir -p /opt/
RUN mkdir /opt/jira-home
RUN curl -O https://storage.googleapis.com/atlassian/atlassian-jira-software-7.1.9.tar.gz
RUN curl -R -O https://storage.googleapis.com/atlassian/jdk-8u101-linux-x64.tar.gz

RUN tar -xvf jdk-8u101-linux-x64.tar.gz
RUN mv jdk1.8.0_101 /opt/

RUN tar -xvf atlassian-jira-software-7.1.9.tar.gz
RUN mv atlassian-jira-software-7.1.9-standalone /opt

ENV JAVA_HOME="/opt/jdk1.8.0_101"
ENV JIRA_HOME="/opt/jira-home"

RUN echo 'jira.home = /opt/jira-home' > \
  /opt/atlassian-jira-software-7.1.9-standalone/atlassian-jira/WEB-INF/classes/jira-application.properties

ENTRYPOINT ["/opt/atlassian-jira-software-7.1.9-standalone/bin/catalina.sh", "run"]
