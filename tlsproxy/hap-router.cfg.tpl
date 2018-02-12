global
    # Log to the syslog-ng sidecar container
    # log syslogng:514 local5

    # SSL config : see https://www.haproxy.com/fr/documentation/aloha/7-0/traffic-management/lb-layer7/tls/
    # Best TLS practises : https://wiki.mozilla.org/Security/Server_Side_TLS

    # Disable SSLv3
    ssl-default-bind-options ssl-min-ver TLSv1.1

    # Ciphers
    ssl-default-bind-ciphers ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!3DES:!MD5:!PSK

    # Increase TLS session cache size and lifetime to avoid computing too many symmetric keys
    tune.ssl.cachesize 100000
    tune.ssl.lifetime 600

    # No warning on startup
    tune.ssl.default-dh-param 2048


# Share config for next blocks using a defaults block
defaults
    mode    http
    timeout connect 5s
    timeout client  50s
    timeout server  50s

    log global
    option  httplog
    option  dontlognull

    balance roundrobin

    option tcp-check
    timeout check 1s

    default-server inter 3s


resolvers dns
    # Always 127.0.0.11 for a Docker container
    # See https://docs.docker.com/engine/userguide/networking/configure-dns/
    nameserver docker-dns 127.0.0.11:53


listen stats
    maxconn 50

    bind *:8081

    stats enable
    stats uri '/'
    stats show-desc 'HAP Router'
    stats show-legends
    stats show-node
    stats realm 'HAP'
    stats auth admin:password
    stats admin if TRUE


frontend frontend
    maxconn 300

    bind *:443 ssl crt /usr/local/etc/haproxy/certs/ alpn http/1.1

    option forwardfor
    option originalto

    # http-request set-header X-Forwarded-Port %[dst_port]
    # http-request add-header X-Forwarded-Proto https if { ssl_fc }

    # Non secure traffic to secure
    ### http-request redirect scheme https if { !ssl_fc }

    default_backend backend


backend backend
    ### option httpchk GET '/healthcheck'
    http-check send-state

    server-template whoami_ 1-${whoami_count} whoami:80 check init-addr none resolvers dns weight 1 minconn 1 maxconn 50 maxqueue 100
