#!/bin/bash -e
# Gestion des containers Docker


usage() {
    cat <<-EOF
Usage: admin.sh COMMANDE

Commandes:
    purge               Purger les containers arrêtés
    ipurge              Purger les images sans repository
    ip CONTAINER...     Adresse
    console CONTAINER   Lancer une console dans un container
    stopall             Arrêter tous les containers
    purgeall            Purger tout ce qui peut l'être
    shell IMAGE         Lancer un shell dans une image
EOF
}


purge_containers() {
    (docker ps -q; docker ps -qa) | sort | uniq -u | while read container
    do
        docker rm $container
    done
}


purge_images() {
    # Ligne 1 : en-têtes. Colonne 1 : repo, colonne 3 : ID image
    docker images --no-trunc | awk 'NR > 1 && $1 == "<none>" { print $3 }' | while read image
    do
        docker rmi $image
    done
}


container_ip() {
    typeset containers="$*"
    docker inspect -f '{{ .NetworkSettings.IPAddress }}' $containers
}


console() {
    typeset container="$1"
    exec docker exec -i -t $container /bin/bash -l
}


stop_all() {
    docker ps -q | while read container
    do
        docker stop $container
    done
}


open_shell() {
    typeset image="$1"
    exec docker run -i -t $image /bin/bash -l
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
    -h | --help | '')
        usage
        ;;
    *)
        echo "Erreur: commande inconnue" >&2
        exit 1
        ;;
esac
