#!/bin/bash -e


usage() {
    cat <<-EOF
Usage: admin.sh COMMANDE

Commandes:
    purge: Purger les containers arrêtés
    ipurge: Purger les images sans repository

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


case "$1" in
    purge)
        purge_containers
        ;;
    ipurge)
        purge_images
        ;;
    -h | --help | '')
        usage
        ;;
    *)
        echo "Erreur: commande inconnue" >&2
        exit 1
        ;;
esac
