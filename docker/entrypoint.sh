#!/bin/sh

set -e

npm set audit false
rake db:migrate

rake assets:precompile
cp -r /app/public/* /assets/

exec "$@"
