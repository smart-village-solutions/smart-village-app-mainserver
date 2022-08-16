#!/bin/sh

set -e

dockerize -wait tcp://saas-database-mysql:3306 -timeout 30s

# npm set audit false
bundle exec rake db:migrate
bundle exec rake assets:precompile
bundle exec rake graphql:schema:dump
cp -r /app/public/* /assets/
rm -f /unicorn.pid

exec "$@"
