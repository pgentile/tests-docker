global
    # Log to the syslog-ng sidecar container
    # log syslogng:514 local5


# Share config for next blocks using a defaults block
defaults
    mode    tcp
    balance roundrobin

    timeout connect 10s
    timeout client  60s
    timeout server  60s


resolvers dns
    # Always 127.0.0.11 for a Docker container
    # See https://docs.docker.com/engine/userguide/networking/configure-dns/
    nameserver docker-dns 127.0.0.11:53


listen stats
    mode http
    maxconn 50

    bind *:8081

    stats enable
    stats uri '/'
    stats show-desc 'Facade'
    stats show-legends
    stats show-node
    stats realm 'HAP'
    stats auth admin:password
    stats admin if TRUE


frontend frontend
    mode    tcp
    bind *:443
 
    default_backend backend


backend backend
    mode    tcp
    server-template router_ 1-2 hap-router:443 check init-addr none resolvers dns weight 1 minconn 1 maxconn 50 maxqueue 100
