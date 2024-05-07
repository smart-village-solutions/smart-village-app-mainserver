# FROM ruby:2.6.8
FROM registry.gitlab.tpwd.de/cmmc-systems/ruby-nginx/ruby-3.3.1

RUN apk update
RUN apk upgrade
RUN apk add --update build-base bash
RUN apk add curl ca-certificates
RUN apk add mariadb-dev
RUN apk add git
# # RUN apk add gcc musl-dev mariadb-connector-c-dev
RUN apk add nodejs
RUN apk add yarn
RUN apk add wget
RUN wget https://dl.min.io/client/mc/release/linux-amd64/mc
RUN chmod +x mc
RUN mv mc /bin

RUN wget http://dl-cdn.alpinelinux.org/alpine/v3.16/community/x86_64/oath-toolkit-oathtool-2.6.7-r1.apk
RUN apk add oath-toolkit-oathtool-2.6.7-r1.apk

# ENV DOCKERIZE_VERSION v0.6.1
# RUN curl -L https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
#   | tar -C /usr/local/bin -xz

# Install 1Password CLI
RUN curl -sSfo op.zip https://cache.agilebits.com/dist/1P/op2/pkg/v2.0.0/op_linux_amd64_v2.0.0.zip \
  && unzip -od /usr/local/bin/ op.zip \
  && rm op.zip
RUN apk add libc6-compat
RUN apk add oath-toolkit

RUN mkdir -p /unicorn
RUN mkdir -p /app
RUN mkdir -p /run/nginx/

WORKDIR /app
COPY . /app

COPY Gemfile Gemfile.lock /app/
RUN chmod +x bin/start-cron.sh

COPY docker/nginx.conf /etc/nginx/http.d/default.conf
COPY docker/unicorn.rb /app/config/unicorn.rb
RUN bundle config set --local without 'development test'
RUN bundle install

RUN bundle exec rake DATABASE_URL=nulldb://user:pass@127.0.0.1/dbname assets:precompile

COPY docker/database.yml /app/config/database.yml

ENTRYPOINT ["/app/docker/entrypoint.sh"]

VOLUME /unicorn
VOLUME /assets

# Start the main process.
CMD ["sh", "-c", "nginx ; bundle exec unicorn -c config/unicorn.rb"]
