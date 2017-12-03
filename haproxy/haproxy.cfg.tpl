global
    log ${syslogng_addr}:514 local5

    #log /dev/log    local5
    #log /dev/log    local5 notice
    #stats socket /run/haproxy/admin.sock mode 660 level admin
    #stats timeout 30s


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
    timeout check 500ms

    default-server inter 3s


resolvers dns
    # Always 127.0.0.11 for a Docker container
    # See https://docs.docker.com/engine/userguide/networking/configure-dns/
    nameserver docker-dns 127.0.0.11:53


listen stats
    bind *:8081
    stats enable
    stats uri '/haproxy'
    stats show-desc 'Zucchini'
    stats show-legends
    stats show-node
    stats realm 'Auth required'
    stats auth foo:bar
    stats admin if TRUE


frontend frontend
    ### Add X-Forwarded-For header
    ### option  forwardfor

    ### maxconn 800
    bind *:8080

    errorfile 503 '/usr/local/etc/haproxy/responses/503.http'

    default_backend app


backend app
    option httpchk GET '/healthcheck'
    http-check send-state

    # Add the correlation ID header if not defined on the origin request
    acl has_correlation_id_header req.hdr(X-Correlation-ID) -m found
    http-request set-header 'X-Correlation-ID' 'CID-%Ts-%rt' unless has_correlation_id_header
    
    # Add the exchange ID header if not defined on the origin request
    acl has_exchange_id_header req.hdr(X-Exchange-ID) -m found
    http-request set-header 'X-Exchange-ID' 'EX-%Ts-%rt' unless has_exchange_id_header
    
    # HaProxy tracability
    http-response add-header 'X-About-HaProxy' '%H %f/%b/%s %fi:%fp/%si:%sp'

    # Redirect web sockets to one server only (state not shared by zucchini)
    acl is_connection_upgrade req.hdr(Connection) -i Upgrade
    acl is_websocket req.hdr(Upgrade) -i WebSocket
    use-server zucchini-instance-1 if is_connection_upgrade is_websocket

    # The first server receive all Web Sockets
    server zucchini-instance-1 zucchini:8080 check port 8081 init-addr none resolvers dns weight 1

    # Please note that the generated server name doesn't match the container name
    server-template zucchini-instance- 2-${app_count} zucchini:8080 check port 8081 init-addr none resolvers dns weight 2
