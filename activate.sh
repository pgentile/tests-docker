boot2docker up

$(boot2docker shellinit)

# Surcharger l'IP avec le hostname boot2docker défini dans /etc/hosts pour ne pas se faire avoir
# avec la vérification SSL des hostnames par fig
boot2docker_ip=$(boot2docker ip)
export DOCKER_HOST=$(echo "$DOCKER_HOST" | sed "s|tcp://$boot2docker_ip|tcp://boot2docker|")
