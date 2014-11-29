#!/usr/bin/python2.7
# -*- coding: utf8 -*-

import os
import sys
import string


# Configurer Nginx

print "Configuration de nginx..."

graphite_host = os.environ['GRAPHITE_PORT_8080_TCP_ADDR']
graphite_port = os.environ['GRAPHITE_PORT_8080_TCP_PORT']

with open('/etc/nginx/nginx.conf.template') as input_f, open('/etc/nginx/nginx.conf', 'w') as output_f:
    template = string.Template(input_f.read())
    output_f.write(template.substitute(
        graphite_host=graphite_host,
        graphite_port=graphite_port,
    ))


# Lancer nginx

print "Lancement de nginx..."

binary = "/usr/sbin/nginx"
args = [binary] + sys.argv[1:]
os.execv(binary, args)
