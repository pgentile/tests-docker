#!/bin/bash
# Gestion des containers Docker

set -e

usage() {
    cat <<-EOF
Usage: admin.sh COMMANDE

Commandes:
    purge               Purger les containers arrêtés
    ipurge              Purger les images sans repository
    ip [CONTAINER...]   Adresse
    console CONTAINER   Lancer une console dans un container
    stopall             Arrêter tous les containers
    purgeall            Purger tout ce qui peut l'être
    shell IMAGE         Lancer un shell dans une image
    hello               Lancer le Hello World
    machineip           IP de la machine courante
    stats               Statistiques sur les containers actifs
EOF
}


error() {
    echo "Error: $*" >&2
    return 1
}


purge_containers() {
    typeset container
    docker ps -a --filter 'status=exited' -q --no-trunc | while read container; do
        docker rm $container || true
    done
}


purge_images() {
    typeset image
    docker images --filter "dangling=true" -q --no-trunc | while read image; do
        docker rmi $image || true
    done
}


container_ip() {
    typeset containers="$*"
    if [[ -z "$containers" ]]; then
        containers=$(docker ps -q --no-trunc)
        [[ -n "$containers" ]] || error "no started container found"
    fi

    typeset template='{{ .Name }} ({{ .Config.Image }}): {{ .NetworkSettings.IPAddress }}'

    docker inspect -f "$template" $containers | sed -e 's@^/@@'
}


console() {
    typeset container="$1"
    exec docker exec -i -t $container bash -l
}


stop_all() {
    typeset containers=$(docker ps -q --no-trunc)
    [[ -z "$containers" ]] || docker stop $containers
}


open_shell() {
    typeset image="$1"
    exec docker run -i -t --entrypoint='bash' $image -l
}


hello() {
    docker run hello-world
}


machine_ip() {
    [[ -n "$DOCKER_MACHINE_NAME" ]] || error "DOCKER_MACHINE_NAME has no value, can't determine machine name"
    docker-machine ip $DOCKER_MACHINE_NAME
}


machine_halt() {
    [[ -n "$DOCKER_MACHINE_NAME" ]] || error "DOCKER_MACHINE_NAME has no value, can't determine machine name"
    docker-machine stop $DOCKER_MACHINE_NAME
}


stats() {
    docker stats $(docker inspect -f "{{ .Name }}" $(docker ps -q))
}


case "$1" in
    purge)
        purge_containers
        ;;
    ipurge)
        purge_images
        ;;
    ip)
        shift
        container_ip $@
        ;;
    console)
        console $2
        ;;
    stopall)
        stop_all
        ;;
    purgeall)
        purge_containers
        purge_images
        ;;
    shell)
        open_shell $2
        ;;
    hello)
        hello
        ;;
    machineip)
        machine_ip
        ;;
    machinehalt)
        machine_halt
        ;;
    stats)
        stats
        ;;
    -h | --help | '')
        usage
        ;;
    *)
        error "Unknown command" || true
        exit 1
        ;;
esac
