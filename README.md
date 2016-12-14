This image consists of the [official Jenkins image](https://hub.docker.com/_/jenkins/)
with Docker and Docker Compose binaries installed for use with the host's Docker installation.

This setup is useful if you want a Dockerized Jenkins to be able to create
new Docker containers for build purposes, without the
[pitfalls of running Docker-in-Docker](https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/).

Example:

    docker run -itd --restart=always \
               -p 8080:8080 -p 50000:50000 \
               -v /var/run/docker.sock:/var/run/docker.sock \
               -v /etc/localtime:/etc/localtime:ro \
               --name jenkins-docker jjlin/jenkins-docker
