#!/usr/bin/env python

import docker
import os
import json
import tempfile
from os import path


tls_config = docker.tls.TLSConfig(
    verify=True,
    client_cert=(
        path.join(os.environ['DOCKER_CERT_PATH'], 'cert.pem'),
        path.join(os.environ['DOCKER_CERT_PATH'], 'key.pem'),
    ),
    ca_cert=path.join(os.environ['DOCKER_CERT_PATH'], 'ca.pem'),
    assert_hostname=False,
)
client = docker.Client(base_url=os.environ['DOCKER_HOST'].replace('tcp://', 'https://'), tls=tls_config)

replica_set_config = dict(
    _id='rs',
    members=[],
)

first_container = None
first_container_ip = None

index = 0
for container in client.containers():
    container_name = container['Names'][0]
    if not container_name.startswith(u'/mongo-rs-node'):
        pass

    container_inspection = client.inspect_container(container_name)
    ip_addr = container_inspection['NetworkSettings']['IPAddress']
    port = container_inspection['NetworkSettings']['Ports']['27017/tcp'][0]['HostPort']
    replica_set_config['members'].append(dict(
        _id=index,
        host="192.168.99.100:{}".format(port),
    ))

    first_container = first_container or container_name
    first_container_ip = first_container_ip or ip_addr

    index += 1

with open('init-rs.js', 'wb') as f:
    f.write('rs.initiate(\n')
    f.write(json.dumps(replica_set_config) + '\n')
    f.write(');\n')
    f.write('\n')
    f.write('sleep(10);\n')
    f.write('rs.status();\n')


print "Please run:\n\n\tdocker run --rm -v {input_js}:/tmp/init-rs.js mongo:3 mongo {host} /tmp/init-rs.js".format(
    input_js=path.abspath('init-rs.js'),
    host=first_container_ip,
)
