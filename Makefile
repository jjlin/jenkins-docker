IMAGE_NAME := jenkins-docker
IMAGE_TAG := latest

LATEST_DOCKER_VERSION := "$(shell ./get-latest-release-tag.sh docker docker | tr -d 'v')"
LATEST_DOCKER_COMPOSE_VERSION := "$(shell ./get-latest-release-tag.sh docker compose)"

image:
	docker build -t "$(IMAGE_NAME):$(IMAGE_TAG)" \
	             --build-arg DOCKER_VERSION="$(LATEST_DOCKER_VERSION)" \
	             --build-arg DOCKER_COMPOSE_VERSION="$(LATEST_DOCKER_COMPOSE_VERSION)" \
	             . 2>&1 | tee build.log

run:
	docker run -itd --restart=always \
	           -p 8080:8080 -p 50000:50000 \
		   -v /var/run/docker.sock:/var/run/docker.sock \
		   -v /etc/localtime:/etc/localtime:ro \
		   --name $(IMAGE_NAME) $(IMAGE_NAME)

kill:
	docker kill $(IMAGE_NAME)

rmf:
	docker rm -f $(IMAGE_NAME)

latest-version-info:
	@echo "Docker: $(LATEST_DOCKER_VERSION)"
	@echo "Docker Compose: $(LATEST_DOCKER_COMPOSE_VERSION)"

clean-dangling-images:
	docker rmi `docker images --filter 'dangling=true' --no-trunc --quiet`

clean-dangling-volumes:
	docker volume rm `docker volume ls --filter 'dangling=true' --quiet`

.PHONY: image run kill rmf latest-version-info \
	clean-dangling-images clean-dangling-volumes
