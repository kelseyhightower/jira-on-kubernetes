# This Dockerfile is not awesome.
# Use it as a starting point for your own Jira image.
FROM centos:7.3.1611

ENV JIRA_HOME="/opt/jira-home" \
    JIRA_RELEASE="7.3.6"

# JDK stuff
RUN curl --location --junk-session-cookies --insecure --output /tmp/jdk-8u131-linux-x64.rpm \
      --header 'Cookie: gpw_e24=http://www.oracle.com/; oraclelicense=accept-securebackup-cookie' \
      http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm && \
    yum localinstall -y /tmp/jdk-8u131-linux-x64.rpm && \
    yum clean all && \
    rm -f /tmp/jdk-8u131-linux-x64.rpm
# Jira stuff
RUN mkdir -p ${JIRA_HOME} && \
    curl --location https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-${JIRA_RELEASE}.tar.gz -o ${JIRA_HOME}/atlassian-jira-software-${JIRA_RELEASE}.tar.gz && \
    tar -xvf ${JIRA_HOME}/atlassian-jira-software-${JIRA_RELEASE}.tar.gz -C /opt/ && \
    rm -f ${JIRA_HOME}/atlassian-jira-software-${JIRA_RELEASE}.tar.gz && \
    echo 'jira.home = ${JIRA_HOME}' > \
        /opt/atlassian-jira-software-${JIRA_RELEASE}-standalone/atlassian-jira/WEB-INF/classes/jira-application.properties

## Postgres driver fix
RUN curl https://jdbc.postgresql.org/download/postgresql-42.1.1.jar --output /tmp/postgresql-42.1.1.jar && \
    rm /opt/atlassian-jira-software-7.3.6-standalone/lib/postgresql-9.1-903.jdbc4-atlassian-hosted.jar && \
    mv /tmp/postgresql-42.1.1.jar /opt/atlassian-jira-software-7.3.6-standalone/lib/postgresql-42.1.1.jar

ENTRYPOINT ["/opt/atlassian-jira-software-7.3.6-standalone/bin/catalina.sh", "run"]
