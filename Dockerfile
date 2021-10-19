FROM ruby:2.6.8

RUN apt-get update \
  && apt-get install -y curl apt-transport-https ca-certificates \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
  && curl -sL https://deb.nodesource.com/setup_12.x | bash \
  && apt-get install -y nodejs \
  && apt-get install -y yarn \
  && apt-get install -y wget \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /usr/src/*

RUN wget https://dl.min.io/client/mc/release/linux-amd64/mc
RUN chmod +x mc
RUN mv mc /bin
RUN mc -help

ENV DOCKERIZE_VERSION v0.6.1
RUN curl -L https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
  | tar -C /usr/local/bin -xz

WORKDIR /app

COPY Gemfile Gemfile.lock /app/
RUN gem install bundler
RUN bundle install

COPY . /app
RUN chmod +x bin/start-cron.sh
# TODO: wie kann assets building ohne DB passieren?
# RUN bundle exec rake assets:precompile

ENTRYPOINT ["/app/docker/entrypoint.sh"]

VOLUME /unicorn
VOLUME /assets

# Start the main process.
CMD ["bundle", "exec", "unicorn", "-c", "./config/unicorn.rb"]
