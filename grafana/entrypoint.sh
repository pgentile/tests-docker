#!/bin/bash -e

error() {
    echo "Erreur : $*" >&2
    exit 1
}


# Configurer Grafana

[[ -n "$GRAPHITE_PORT_8080_TCP_ADDR" ]] || error "Variable GRAPHITE_PORT_8080_TCP_ADDR non definie"
[[ -n "$GRAPHITE_PORT_8080_TCP_PORT" ]] || error "Variable GRAPHITE_PORT_8080_TCP_PORT non definie"


cat >/usr/share/grafana/config.js <<EOF
define(['settings'],
function (Settings) {
  
  return new Settings({

    /* Data sources
    * ========================================================
    * Datasources are used to fetch metrics, annotations, and serve as dashboard storage
    *  - You can have multiple of the same type.
    *  - grafanaDB: true    marks it for use for dashboard storage
    *  - default: true      marks the datasource as the default metric source (if you have multiple)
    *  - basic authentication: use url syntax http://username:password@domain:port
    */

    // Graphite & Elasticsearch example setup
    datasources: {
      graphite: {
        type: 'graphite',
        url: "http://${GRAPHITE_PORT_8080_TCP_ADDR}:${GRAPHITE_PORT_8080_TCP_PORT}",
      },
      /*
      elasticsearch: {
        type: 'elasticsearch',
        url: "http://my.elastic.server.com:9200",
        index: 'grafana-dash',
        grafanaDB: true,
      }
      */
    },

    /* Global configuration options
    * ========================================================
    */

    // specify the limit for dashboard search results
    search: {
      max_results: 20
    },

    // default home dashboard
    default_route: '/dashboard/file/default.json',

    // set to false to disable unsaved changes warning
    unsaved_changes_warning: true,

    // set the default timespan for the playlist feature
    // Example: "1m", "1h"
    playlist_timespan: "1m",

    // If you want to specify password before saving, please specify it bellow
    // The purpose of this password is not security, but to stop some users from accidentally changing dashboards
    admin: {
      password: ''
    },

    // Change window title prefix from 'Grafana - <dashboard title>'
    window_title_prefix: 'Grafana - ',

    // Add your own custom panels
    plugins: {
      // list of plugin panels
      panels: [],
      // requirejs modules in plugins folder that should be loaded
      // for example custom datasources
      dependencies: [],
    }

  });
});
EOF


# Lancer le serveur Nginx

exec nginx