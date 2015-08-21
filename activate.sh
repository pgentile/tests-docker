export DOCKER_MACHINE_NAME=default

docker-machine start $DOCKER_MACHINE_NAME
eval $(docker-machine env $DOCKER_MACHINE_NAME)
