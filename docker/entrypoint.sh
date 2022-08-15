#!/bin/sh

set -e

DB=${DB_HOST:-saas-database-service:3306}

dockerize -wait tcp://$DB -timeout 30s

npm set audit false
bundle exec rake db:migrate

bundle exec rake graphql:schema:dump
cp -r /app/public/* /assets/
rm -f /unicorn.pid

exec "$@"
