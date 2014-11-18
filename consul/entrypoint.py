#!/usr/bin/python2.7
# -*- coding: utf8 -*-

import pwd
import os
import sys


user = pwd.getpwnam("consul")


# Modifier les doits sur le répertoire des données

os.chown("/var/consul", user.pw_uid, user.pw_gid)


# Lancer Consul en droppant les privilèges root

os.setgroups([user.pw_gid])
os.setgid(user.pw_gid)
os.setuid(user.pw_uid)

consul_bin = "/usr/bin/consul"
args = [consul_bin, "agent", "-config-dir", "/etc/consul.d"] + sys.argv[1:]
os.execv(consul_bin, args)
