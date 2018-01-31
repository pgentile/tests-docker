global
    # Log to the syslog-ng sidecar container
    log syslogng:514 local5


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
    bind *:8081
    maxconn 50

    stats enable
    stats uri '/haproxy'
    stats show-desc 'Zucchini'
    stats show-legends
    stats show-node
    stats realm 'Auth required'
    stats auth admin:password
    stats admin if TRUE


frontend frontend-zucchini
    ### Add X-Forwarded-For header
    ### option  forwardfor

    bind *:8080
    maxconn 300

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

    # Redirect web sockets to one server only (state not shared by zucchini)
    acl is_connection_upgrade req.hdr(Connection) -i Upgrade
    acl is_websocket req.hdr(Upgrade) -i WebSocket
    use-server srv-zucchini-instance-1 if is_connection_upgrade is_websocket

    # The first server receive all Web Sockets
    server srv-zucchini-instance-1 zucchini:8080 check port 8081 init-addr none resolvers dns weight 1 minconn 1 maxconn 50 maxqueue 100

    # Please note that the generated server name doesn't match the container name
    server-template srv-zucchini-instance- 2-${app_count} zucchini:8080 check port 8081 init-addr none resolvers dns weight 2 minconn 1 maxconn 50 maxqueue 100
