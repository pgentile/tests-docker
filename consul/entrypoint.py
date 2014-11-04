#!/usr/bin/python
# -*- coding: utf8 -*-

import grp
import pwd
import os
import sys


user = pwd.getpwnam("consul")


# Modifier les doits sur le répertoire des données

os.chown("/usr/local/var/consul", user.pw_uid, user.pw_gid)


# Lancer Consul en tant qu'user consul

os.setgid(user.pw_gid)
os.setuid(user.pw_uid)

consul_bin = "/usr/local/bin/consul"
args = [consul_bin, "agent", "-config-dir", "/usr/local/etc/consul.d"] + sys.argv[1:]
os.execv(consul_bin, args)
