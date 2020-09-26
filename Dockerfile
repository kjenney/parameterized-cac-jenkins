FROM jenkins/jenkins:2.249.1-lts-alpine

ENV CASC_JENKINS_CONFIG=/usr/share/jac

USER root

COPY plugins.txt /tmp/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /tmp/plugins.txt

RUN mkdir $CASC_JENKINS_CONFIG
COPY jac/ $CASC_JENKINS_CONFIG

USER jenkins
