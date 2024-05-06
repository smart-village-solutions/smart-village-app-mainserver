<img src="https://github.com/smart-village-solutions/smart-village-app-app/raw/master/smart-village-app-logo.png" width="150">

# Smart Village App - Main-Server

[![Maintainability](https://api.codeclimate.com/v1/badges/e3b4b85a95fa2edf58a4/maintainability)](https://codeclimate.com/github/ikuseiGmbH/smart-village-app-mainserver/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/e3b4b85a95fa2edf58a4/test_coverage)](https://codeclimate.com/github/ikuseiGmbH/smart-village-app-mainserver/test_coverage)

Please visit the german website to get in touch with us and present your ideas and visions: https://smart-village.app.

&nbsp;

This main-server is one main part of the whole Smart Village App project. For more information visit https://github.com/ikuseiGmbH/smart-village-app.

## Setup process

### Common setup saas branch

#### 1. Ruby installation

- for Ruby version issues

```bash
export CFLAGS="-DUSE_FFI_CLOSURE_ALLOC"
export PKG_CONFIG_PATH="$(brew --prefix openssl@1.1)/lib/pkgconfig"
ruby-install 3.3.1 -- --with-openssl-dir=$(brew --prefix openssl@1.1)
```

#### 2. Bundler installation

```bash
gem install bundler -v '2.3.20'
```

### Master key configuration

Create `config/master.key` if needed with the correct key.

### Database configuration

Create a `config/database.yml` file with e.g. the following content:

```yml
default: &default
  adapter: mysql2
  encoding: utf8mb4
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: root
  password:
  socket: /tmp/mysql.sock

development:
  <<: *default
  database: smart_village

test:
  <<: *default
  database: smart_village_test
```

### Database and user setup

#### 1. Ru the following commands

```bash
rake db:create db:migrate
```

#### Import a SQL dump or use

```bash
rake db:seed
```

#### 3. Change the user password in Rails console:

```bash
user = User.first
user.password = user.password_confirmation = "my_new_password"
user.save
```

### Run the server locally

```bash
rails s
```

### Editing `/etc/hosts`

Add e.g. the following entries to your `/etc/hosts` file:

```bash
127.0.0.1 minio.docker.localhost
127.0.0.1 server.smart-village.local
127.0.0.1 test.server.smart-village.local

127.0.0.1 foo.server.smart-village.local
127.0.0.1 foo.cms.smart-village.local
127.0.0.1 bar.server.smart-village.local
127.0.0.1 bar.cms.smart-village.local

# Add other local domain mappings as needed
```

### Login

- login into Main-Server at e.g. http://test.server.smart-village.local with user name "admin@smart-village.app" and password “my_new_password”

## User management

At http://test.server.smart-village.local/accounts you can manage users and also assign permissions. Important!!! Without the correct permissions, you cannot log in and will receive the error message:

```
Error! E-Mail oder Passwort ist falsch.
```

### GraphQL API

There is also the option to use the GraphQL API at http://test.server.smart-village.local/graphiql and send various requests. Examples can be found in the doc folder `doc/poi_mutation_example.graphql` and `doc/poi_mutation_example.graphql`.

## Tech Stack

- Ruby version: 3.0.3
- Rails version: 6.1.7
