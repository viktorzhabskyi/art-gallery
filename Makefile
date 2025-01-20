APP = art-gallery
REGISTRY = 638693734667.dkr.ecr.us-east-1.amazonaws.com
VERSION=$(shell git rev-parse --short HEAD)
TARGET_OS = linux#linux darwin windows
TARGET_ARCH = amd64#arm64
TARGET_FOLDER := backend_redis
TAG = ${REGISTRY}/${APP}:${TARGET_FOLDER}-${VERSION}-$(TARGET_OS)-${TARGET_ARCH}
DOCKER_COMPOSE_FILE = build/docker-compose.yml

image:
	docker build --build-arg TARGET_FOLDER=$(TARGET_FOLDER) \
		--platform $(TARGET_OS)/$(TARGET_ARCH) \
		--file ./infra/build/Dockerfile \
		--tag $(TAG) .

update-compose:
	yq eval '.services.$(TARGET_FOLDER).image = "$(TAG)"' -i $(DOCKER_COMPOSE_FILE)

builds:
	$(MAKE) image TARGET_FOLDER=backend_redis
	$(MAKE) image TARGET_FOLDER=backend_rds
	$(MAKE) image TARGET_FOLDER=frontend

docker-login:
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $(REGISTRY)

push: docker-login
	docker push $(TAG)

tag:
	@echo $(TAG)

bunch-push: docker-login
	docker push ${REGISTRY}/${APP}:backend_rds-${VERSION}-$(TARGET_OS)-${TARGET_ARCH}
	docker push ${REGISTRY}/${APP}:backend_redis-${VERSION}-$(TARGET_OS)-${TARGET_ARCH}
	docker push ${REGISTRY}/${APP}:frontend-${VERSION}-$(TARGET_OS)-${TARGET_ARCH}

clean:
	docker images | grep "bookstore" | awk '{print $3}' | xargs -r docker rmi -f

up:
	 docker-compose -f ./infra/build/docker-compose.yml up -d --build

down:
	docker-compose -f ./infra/build/docker-compose.yml down