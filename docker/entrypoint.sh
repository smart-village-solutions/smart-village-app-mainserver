#!/bin/sh

set -e

DB=${DB_HOST:-db:3306}

dockerize -wait tcp://$DB -timeout 30s

npm set audit false
bundle exec rake db:migrate

# TODO: Sobald Assets build im Dockerfile ohne DB funktioniert,
# kann der Schritt hier entfernt werden
bundle exec rake assets:precompile
bundle exec rake graphql:schema:dump
cp -r /app/public/* /assets/
rm -f /unicorn.pid

exec "$@"
