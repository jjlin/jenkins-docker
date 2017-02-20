FROM jenkins

#
# If no specific value is provided via `docker build --build-arg ...`,
# then the latest released version is implied.
#
ARG DOCKER_VERSION
ARG DOCKER_COMPOSE_VERSION

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
COPY get-latest-release-tag.sh /usr/local/bin/
RUN docker_version=${DOCKER_VERSION:-$(get-latest-release-tag.sh docker docker | tr -d 'v')} \
 && docker_compose_version=${DOCKER_COMPOSE_VERSION:-$(get-latest-release-tag.sh docker compose)} \
 && echo "Versions" \
 && echo "========" \
 && echo "Docker: ${docker_version}" \
 && echo "Docker Compose: ${docker_compose_version}" \
 && cd /tmp \
 && ${CURL} -o docker.tgz \
            https://get.docker.com/builds/$(uname -s)/$(uname -m)/docker-${docker_version}.tgz \
 && tar -xf docker.tgz \
 && chown root:root docker/docker \
 && chmod 755 docker/docker \
 && mv docker/docker /usr/bin \
 && rm -rf docker* \
 && groupadd -r docker \
 && usermod -aG docker ${JENKINS_USER} \
 && cd /usr/bin \
 && ${CURL} -o docker-compose \
            https://github.com/docker/compose/releases/download/${docker_compose_version}/docker-compose-$(uname -s)-$(uname -m) \
 && chown root:root docker-compose \
 && chmod 755 docker-compose

USER ${JENKINS_USER}
WORKDIR ${JENKINS_HOME}
