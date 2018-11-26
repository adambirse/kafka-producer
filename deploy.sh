#!/bin/bash

set -e

extract_secrets() {
echo $GCLOUD_SERVICE_KEY | base64 --decode -i > ${HOME}/gcloud-service-key.json
gcloud auth activate-service-account --key-file ${HOME}/gcloud-service-key.json
}

prepare_yaml() {

cp deployment_template.yml deployment.yml

sed -i.bak "s/_PROJECT_NAME_/$PROJECT_NAME/g" deployment.yml
sed -i.bak "s/_DOCKER_IMAGE_NAME_/$DOCKER_IMAGE_NAME/g" deployment.yml
sed -i.bak "s/_TRAVIS_COMMIT_/$TRAVIS_COMMIT/g" deployment.yml

}

prepare_cloud() {

gcloud --quiet config set project $PROJECT_NAME
gcloud --quiet config set container/cluster $CLUSTER_NAME
gcloud --quiet config set compute/zone ${CLOUDSDK_COMPUTE_ZONE}
gcloud --quiet container clusters get-credentials $CLUSTER_NAME

}

build_and_push() {

cd $TRAVIS_BUILD_DIR/docker/build_context
docker build -t gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE_NAME}:$TRAVIS_COMMIT .
cd $TRAVIS_BUILD_DIR

cd build/
gcloud docker -- push gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE_NAME}
cd $TRAVIS_BUILD_DIR

yes | gcloud beta container images add-tag gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE_NAME}:$TRAVIS_COMMIT gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE_NAME}:latest

}

deploy() {

kubectl config view
kubectl config current-context

kubectl apply -f deployment.yml
kubectl apply -f service.yml

}

extract_secrets
prepare_yaml
prepare_cloud
build_and_push
deploy

