#!/bin/bash -e

/etc/init.d/postgresql start

cd /usr/share/redmine
exec ruby bin/rails server webrick -e production -b 0.0.0.0
