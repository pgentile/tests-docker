#!/bin/bash

set -e
set -x

# Nantes 1
curl -XPUT http://localhost:8500/v1/agent/service/register -d '{
  "ID": "redis-nantes-1-1",
  "Name": "redis",
  "Port": 8000
}'

# Nantes 2
curl -XPUT http://localhost:8501/v1/agent/service/register -d '{
  "ID": "redis-nantes-2-1",
  "Name": "redis",
  "Port": 8000
}'

# Paris 1
curl -XPUT http://localhost:8510/v1/agent/service/register -d '{
  "ID": "redis-paris-1-1",
  "Name": "redis",
  "Port": 8000
}'

# Paris 2
curl -XPUT http://localhost:8511/v1/agent/service/register -d '{
  "ID": "redis-paris-2-1",
  "Name": "redis",
  "Port": 8000
}'


# Delete query
curl -XDELETE  http://localhost:8500/v1/query/redis

# Add query
curl -XPOST http://localhost:8500/v1/query -d '{
  "Name": "redis",
  "Service": {
    "Service": "redis",
    "Failover": {
      "NearestN": 3,
      "Datacenters": ["paris"]
    },
    "OnlyPassing": false
  },
  "DNS": {
    "TTL": "10s"
  }
}'

# Execute query, Nantes 1
curl http://localhost:8500/v1/query/redis/execute | jq

# DNS query, Nantes 1
dig @127.0.0.1 -p 8600 redis.query.consul

