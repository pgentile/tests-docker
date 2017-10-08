#!/bin/bash

exec mongo --host testrs/mongo1,mongo2,mongo3,mongo4,mongo5 "$@"
