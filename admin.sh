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
EOF
}


error() {
    echo "Error: $*" >&2
    return 1
}


purge_containers() {
    typeset containers=$(docker ps -a --filter 'exited != null' -q --no-trunc)
    [[ -z "$containers" ]] || docker rm $containers
}


purge_images() {
    typeset images=$(docker images --filter "dangling=true" -q --no-trunc)
    [[ -z "$images" ]] || docker rmi $images
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
    exec docker run -i -t $image bash -l
}


hello() {
    docker run hello-world
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
    -h | --help | '')
        usage
        ;;
    *)
        error "Unknown command"
        exit 1
        ;;
esac
