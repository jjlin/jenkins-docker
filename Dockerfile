FROM jenkins

ARG DOCKER_VERSION="1.12.4"
ARG DOCKER_COMPOSE_VERSION="1.9.0"
ARG CURL="curl -sSL"

#
# Values derived from <https://github.com/jenkinsci/docker/blob/master/Dockerfile>.
# `ENV JENKINS_HOME=...` is inherited, so it doesn't need to be redefined here.
#
ARG JENKINS_USER="jenkins"

#
# Install Docker and Docker Compose (and its bash completion).
#
USER root
RUN ${CURL} -o /tmp/docker.tgz \
            https://get.docker.com/builds/$(uname -s)/$(uname -m)/docker-${DOCKER_VERSION}.tgz \
 && tar -C /tmp -xf /tmp/docker.tgz \
 && chown root:root /tmp/docker/* \
 && chmod 755 /tmp/docker/* \
 && mv /tmp/docker/* /usr/bin \
 && rm -rf /tmp/docker* \
 && groupadd -r docker \
 && usermod -aG docker ${JENKINS_USER} \
 && ${CURL} -o /usr/bin/docker-compose \
            https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m) \
 && chown root:root /usr/bin/docker-compose \
 && chmod 755 /usr/bin/docker-compose \
 && ${CURL} -o /etc/bash_completion.d/docker-compose \
            https://raw.githubusercontent.com/docker/compose/${DOCKER_COMPOSE_VERSION}/contrib/completion/bash/docker-compose

USER ${JENKINS_USER}
WORKDIR ${JENKINS_HOME}
