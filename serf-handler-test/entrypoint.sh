#!/bin/bash -e

env | sort
echo

exec serf agent -config-dir /etc/serf.d/ -join $SERFBASE_PORT_7946_TCP_ADDR:$SERFBASE_PORT_7946_TCP_PORT $@
