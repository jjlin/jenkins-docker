IMAGE_NAME := jenkins-docker
IMAGE_TAG := latest

image:
	IMAGE_NAME=$(IMAGE_NAME):$(IMAGE_TAG) \
	./hooks/build 2>&1 | tee build.log

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
	@echo "Docker: $(shell ./get-latest-docker-release.sh edge)"
	@echo "Docker Compose: $(shell ./get-latest-release-tag.sh docker compose)"

clean-dangling-images:
	docker rmi `docker images --filter 'dangling=true' --no-trunc --quiet`

clean-dangling-volumes:
	docker volume rm `docker volume ls --filter 'dangling=true' --quiet`

.PHONY: image run kill rmf latest-version-info \
	clean-dangling-images clean-dangling-volumes
