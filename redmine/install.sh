#!/bin/bash

set -e

cd /usr/share/redmine
rake db:migrate
rake redmine:load_default_data
