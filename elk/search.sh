#!/bin/bash

set -e
set -x

curl -v http://elastic:changeme@localhost:9200/_search -H 'Content-Type: application/json' --data @- <<EOF | jq
{
  "_source": [
    "scenario_name",
    "group_name",
    "request_name",
    "status",
    "http_status",
    "@timestamp",
    "end_date",
    "duration_ms",
    "gatling_user_id"
  ],
  "query": {
    "bool": {
      "filter": [
        {
            "term": { "_type": "gatling_request" }
        },
        {
            "term": { "http_status": "200" }
        }
      ]
    }
  },
  "aggs": {
    "scenario_name": {
      "terms": {
        "field": "scenario_name.keyword",
        "size": 100,
        "order": { "_term": "asc" }
      },
      "aggs": {
        "group_name": {
          "terms": {
            "field": "group_name.keyword",
            "size": 100,
            "order": { "_term": "asc" }
          },
          "aggs": {
            "request_name": {
              "terms": {
                "field": "request_name.keyword",
                "size": 100,
                "order": { "_term": "asc" }
              },
              "aggs": {
                "min_duration_ms": {
                    "min": { "field": "duration_ms" }
                },
                "max_duration_ms": {
                    "max": { "field": "duration_ms" }
                },
                "avg_duration_ms": {
                    "avg": { "field": "duration_ms" }
                },
                "duration_percentiles_ms": {
                    "percentiles": {
                        "field": "duration_ms",
                        "percents" : [50, 90, 95, 99, 99.9]
                    }
                }
              }
            }
          }
        }
      }
    }
  }
}
EOF