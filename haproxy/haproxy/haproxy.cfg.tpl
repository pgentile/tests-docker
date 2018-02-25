global
    # Log to the syslog-ng sidecar container
    log syslogng:514 local5

    # SSL config : see https://www.haproxy.com/fr/documentation/aloha/7-0/traffic-management/lb-layer7/tls/
    # Best TLS practises : https://wiki.mozilla.org/Security/Server_Side_TLS

    # Disable SSLv3
    ssl-default-bind-options ssl-min-ver TLSv1.2

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
    stats uri '/haproxy'
    stats show-desc 'Zucchini'
    stats show-legends
    stats show-node
    stats realm 'Auth required'
    stats auth admin:password
    stats admin if TRUE


frontend frontend-zucchini
    maxconn 300

    bind *:80
    bind *:443 ssl crt /usr/local/etc/haproxy/certs/ alpn http/1.1

    # Dropwizard, used by Zucchini, understands X-Forwarded-* headers
    # See http://www.dropwizard.io/1.2.2/docs/manual/configuration.html
    http-request set-header X-Forwarded-Port %[dst_port]
    http-request add-header X-Forwarded-Proto https if { ssl_fc }

    # Non secure traffic to secure
    acl is_non_secure ssl_fc,not
    http-request redirect scheme https if is_non_secure

    default_backend backend-zucchini

    errorfile 503 '/usr/local/etc/haproxy/responses/503.http'

    # Add the correlation ID header if not defined on the origin request
    acl has_correlation_id_header req.hdr(X-Correlation-ID) -m found
    http-request set-header 'X-Correlation-ID' 'CID-%Ts-%rt' unless has_correlation_id_header
    
    # Add the exchange ID header if not defined on the origin request
    acl has_exchange_id_header req.hdr(X-Exchange-ID) -m found
    http-request set-header 'X-Exchange-ID' 'EX-%Ts-%rt' unless has_exchange_id_header
    
    # HaProxy tracability
    http-response add-header 'X-About-HaProxy' '%H %f/%b/%s %fi:%fp/%si:%sp'


backend backend-zucchini
    option httpchk GET '/healthcheck'
    http-check send-state

    # Redirect web sockets to one server only (state is not shared by Zucchini)
    acl is_connection_upgrade req.hdr(Connection) -i Upgrade
    acl is_websocket req.hdr(Upgrade) -i WebSocket
    use-server srv-zucchini-instance-1 if is_connection_upgrade is_websocket

    # The first server receive all Web Sockets
    server srv-zucchini-instance-1 zucchini:8080 check port 8081 init-addr none resolvers dns weight 1 minconn 1 maxconn 50 maxqueue 100

    # Please note that the generated server name doesn't match the container name
    server-template srv-zucchini-instance- 2-${app_count} zucchini:8080 check port 8081 init-addr none resolvers dns weight 2 minconn 1 maxconn 50 maxqueue 100
