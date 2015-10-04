#!/bin/bash

set -e
set -x

URL=http://$ELASTICSEARCH_PORT_9200_TCP_ADDR:$ELASTICSEARCH_PORT_9200_TCP_PORT

sleep 20

curl -D- -XPUT $URL/words

curl -D- -XPUT $URL/words/_mapping/w -d '
{
    "w" : {
        "properties" : {
            "f1" : {"type" : "integer", "store" : true, "include_in_all": true },
            "f2" : {"type" : "string", "store" : true, "analyzer": "french", "include_in_all": true }
        }
    }
}
'

sleep 3

stream2es generator \
    --target $URL/words/w \
    --fields f1:int:128,f2:str:20 \
    --dictionary /usr/share/dict/french \
    --max-docs 1000

echo "Done, will wait..."
sleep 3600
