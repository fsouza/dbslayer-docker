#!/bin/bash -e

IMAGE_NAME=fsouza/dbslayer

docker build -t ${IMAGE_NAME}:latest .

if [ -n "${TRAVIS_TAG}" ]; then
	docker tag ${IMAGE_NAME}:latest ${IMAGE_NAME}:${TRAVIS_TAG}
	docker tag ${IMAGE_NAME}:latest ${IMAGE_NAME}:${TRAVIS_TAG%%.*}
fi

if [ "${TRAVIS_PULL_REQUEST}" != "false" ]; then
	echo >&2 "Skipping docker push on pull request ${TRAVIS_PULL_REQUEST}..."
	exit 0
fi

if [ "${TRAVIS_BRANCH}" != "master" ] && [ -z "${TRAVIS_TAG}" ]; then
	echo >&2 "Skipping docker push on branch ${TRAVIS_BRANCH}"
	exit 0
fi

docker login -u "${DOCKER_USERNAME}" -p "${DOCKER_PASSWORD}"
docker push ${IMAGE_NAME}
