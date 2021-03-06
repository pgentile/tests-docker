#!/bin/bash
# Gestion des containers Docker

set -e


usage() {
    cat <<-EOF
Usage: admin.sh COMMANDE

Commandes:
    purge               Purger les containers arrêtés
    ipurge              Purger les images sans repository
    purgeall            Purger tout ce qui peut l'être
    purgevolumes        Purger les volumes
    ip [CONTAINER...]   Adresse
    console CONTAINER   Lancer une console dans un container
    stopall             Arrêter tous les containers
    shell IMAGE         Lancer un shell dans une image
    hello               Lancer le Hello World
    stats               Statistiques sur les containers actifs
    iupdate             Mettre a jour les images
EOF
}


error() {
    echo "Error: $*" >&2
    return 1
}


purge_containers() {
    typeset container
    docker container ps -a --filter 'status=exited' -q --no-trunc | while read container; do
        docker container rm $container || true
    done
}


purge_images() {
    typeset image
    docker image list --filter "dangling=true" -q --no-trunc | while read image; do
        docker image rm $image || true
    done
}


purge_volumes() {
    typeset count=$(docker ps -aq | wc -l | awk '{ print $0 }')
    if [[ "$count" -eq 0 ]]; then
        docker volume ls -q | xargs -n 1 docker volume rm
    else
        error "$count active container(s) found, can't purge all volumes"
        return 1
    fi
}


prune() {
    docker system prune -f
}


container_ip() {
    typeset containers="$*"
    if [[ -z "$containers" ]]; then
        containers=$(docker container ps -q --no-trunc)
        [[ -n "$containers" ]] || error "no started container found"
    fi

    typeset template='{{ .Name }} ({{ .Config.Image }}): {{ .NetworkSettings.IPAddress }}'

    docker container inspect -f "$template" $containers | sed -e 's@^/@@'
}


console() {
    typeset container="$1"
    shift

    if [[ $# -eq 0 ]]; then
        # Extract console command from labels of container. If not found, use bash
        # Label must be: org.example.console
        typeset console_command=$(docker container inspect -f '{{ index .Config.Labels "org.example.console" }}' $container)
        [[ -z "$console_command" ]] && console_command='bash -l'

        echo "[ADMIN] Connecting to container $container with console command: $console_command"
        exec docker container exec -i -t $container $console_command
    else
        exec docker container exec -i -t $container "$@"
    fi
}


stop_all() {
    typeset containers=$(docker container ps -q --no-trunc)
    [[ -z "$containers" ]] || docker container stop $containers
}


open_shell() {
    typeset image="$1"
    exec docker container run -i -t --entrypoint='bash' $image -l
}


hello() {
    docker container run hello-world
}


stats() {
    docker stats $(docker inspect -f "{{ .Name }}" $(docker ps -q) | sort)
}


update_images() {
    docker image list --format '{{ .Repository }}:{{ .Tag }}' | while read image; do
        docker image pull $image || true
    done
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
        shift
        container=$1
        shift
        console $container "$@"
        ;;
    stopall)
        stop_all
        ;;
    purgeall)
        purge_containers
        purge_images
        prune
        ;;
    purgevolumes)
        purge_volumes
        ;;
    shell)
        open_shell $2
        ;;
    hello)
        hello
        ;;
    stats)
        stats
        ;;
    iupdate)
        update_images
        ;;
    -h | --help | '')
        usage
        ;;
    *)
        error "Unknown command" || true
        exit 1
        ;;
esac
