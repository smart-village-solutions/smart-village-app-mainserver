#!/bin/sh

set -e

DB=${DB_HOST:-db:3306}

dockerize -wait tcp://$DB -timeout 30s

npm set audit false
rake db:migrate

rake assets:precompile
cp -r /app/public/* /assets/

exec "$@"
