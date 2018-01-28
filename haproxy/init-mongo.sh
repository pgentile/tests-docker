#!/bin/bash

set -e

exec docker run --network zucchini-mongo --rm pgentile/zucchini-ui-mongo mongo/zucchini
