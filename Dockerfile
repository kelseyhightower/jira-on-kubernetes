# This Dockerfile is not awesome.
# Use it as a starting point for your own Jira image.
FROM centos:7.2.1511

ENV JIRA_HOME="/opt/jira-home" \
    JIRA_RELEASE="7.1.9" \
    JDK="8u60-b27"

# JDK stuff
RUN curl --location --junk-session-cookies --insecure --output /tmp/jdk-${JDK}.rpm \
        --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/${JDK}/jdk-$(echo $JDK | cut -d- -f1)-linux-x64.rpm && \
    yum localinstall -y /tmp/jdk-${JDK}.rpm && \
    yum clean all && \
    rm -f /tmp/jdk-${JDK}.rpm

# Jira stuff
RUN mkdir -p ${JIRA_HOME} && \
    curl --location https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-${JIRA_RELEASE}.tar.gz -o ${JIRA_HOME}/atlassian-jira-software-${JIRA_RELEASE}.tar.gz && \
    tar -xvf ${JIRA_HOME}/atlassian-jira-software-${JIRA_RELEASE}.tar.gz -C /opt/ && \
    rm -f ${JIRA_HOME}/atlassian-jira-software-${JIRA_RELEASE}.tar.gz && \
    echo 'jira.home = ${JIRA_HOME}' > \
        /opt/atlassian-jira-software-${JIRA_RELEASE}-standalone/atlassian-jira/WEB-INF/classes/jira-application.properties

ENTRYPOINT ["/opt/atlassian-jira-software-7.1.9-standalone/bin/catalina.sh", "run"]
