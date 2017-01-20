FROM jenkins

ARG DOCKER_VERSION="1.13.0"
ARG DOCKER_COMPOSE_VERSION="1.10.0"
ARG CURL="curl -sSL"

#
# Values derived from <https://github.com/jenkinsci/docker/blob/master/Dockerfile>.
# `ENV JENKINS_HOME=...` is inherited, so it doesn't need to be redefined here.
#
ARG JENKINS_USER="jenkins"

#
# Install Docker (client only) and Docker Compose.
#
# See <https://docs.docker.com/engine/installation/binaries/#/url-patterns-for-static-binaries>
# for docs on constructing links to static binaries.
#
USER root
RUN cd /tmp \
 && ${CURL} -o docker.tgz \
            https://get.docker.com/builds/$(uname -s)/$(uname -m)/docker-${DOCKER_VERSION}.tgz \
 && tar -xf docker.tgz \
 && chown root:root docker/docker \
 && chmod 755 docker/docker \
 && mv docker/docker /usr/bin \
 && rm -rf docker* \
 && groupadd -r docker \
 && usermod -aG docker ${JENKINS_USER} \
 && cd /usr/bin \
 && ${CURL} -o docker-compose \
            https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m) \
 && chown root:root docker-compose \
 && chmod 755 docker-compose

USER ${JENKINS_USER}
WORKDIR ${JENKINS_HOME}
