[![](https://images.microbadger.com/badges/version/jjlin/jenkins-docker.svg)](https://microbadger.com/images/jjlin/jenkins-docker)
[![](https://images.microbadger.com/badges/image/jjlin/jenkins-docker.svg)](https://microbadger.com/images/jjlin/jenkins-docker)

This image consists of the [official Jenkins LTS image](https://hub.docker.com/r/jenkins/jenkins/)
with Docker and Docker Compose binaries included for use with the host's Docker installation.
It is [linked](https://docs.docker.com/docker-hub/builds/#repository-links) to the
[Jenkins](https://hub.docker.com/r/jenkins/jenkins/) and [Docker](https://hub.docker.com/_/docker/)
repositories for automatic rebuilds on upstream updates.

This setup is useful if you want a Dockerized Jenkins to be able to create
new Docker containers for build purposes, without the
[pitfalls of running Docker-in-Docker](https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/).

Example:

    docker run -itd --restart=always \
               -p 8080:8080 -p 50000:50000 \
               -v /var/run/docker.sock:/var/run/docker.sock \
               -v /etc/localtime:/etc/localtime:ro \
               -e JAVA_OPTS="-Duser.timezone=Antarctica/South_Pole" \
               --name jenkins-docker jjlin/jenkins-docker
