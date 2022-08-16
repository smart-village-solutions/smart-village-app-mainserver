# FROM ruby:2.6.8
FROM registry.gitlab.tpwd.de/cmmc-systems/ruby-nginx/ruby-3.1.2

RUN apk update
RUN apk add curl ca-certificates
RUN apk add mariadb-dev
# RUN apk add gcc musl-dev mariadb-connector-c-dev
RUN apk add nodejs
RUN apk add yarn
RUN apk add wget
RUN wget https://dl.min.io/client/mc/release/linux-amd64/mc
RUN chmod +x mc
RUN mv mc /bin
RUN mc -help

# ENV DOCKERIZE_VERSION v0.6.1
# RUN curl -L https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
#   | tar -C /usr/local/bin -xz

# RUN pip install mysqlclient

WORKDIR /app
COPY . /app

RUN mkdir -p /app/.bundle
RUN chmod +w /app/.bundle

# COPY Gemfile Gemfile.lock /app/
RUN gem install bundler
RUN bundle install

RUN chmod +x bin/start-cron.sh

COPY docker/nginx.conf /etc/nginx/http.d/default.conf
COPY docker/unicorn.rb /app/config/unicorn.rb

RUN bundle exec rake DATABASE_URL=nulldb://user:pass@127.0.0.1/dbname assets:precompile

COPY docker/database.yml /app/config/database.yml

ENTRYPOINT ["/app/docker/entrypoint.sh"]

VOLUME /unicorn
VOLUME /assets

# Start the main process.
# CMD ["bundle", "exec", "unicorn", "-c", "./config/unicorn.rb"]
CMD ["sh", "-c", "nginx ; bundle exec unicorn -c config/unicorn.rb"]
