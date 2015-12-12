#!/bin/bash

set -e

cd /usr/share/redmine
exec ruby bin/rails server webrick -e production -b 0.0.0.0 -p 8080
