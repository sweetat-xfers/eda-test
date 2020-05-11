# gets the docker image of ruby 2.5 and lets us build on top of that
FROM ruby:latest

# install rails dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs libsqlite3-dev

# create a folder /myapp in the docker container and go into that folder
RUN mkdir /rails_app
WORKDIR /rails_app

COPY rails_app/Gemfile /rails_app/Gemfile
COPY rails_app/Gemfile.lock /rails_app/Gemfile.lock

# Run bundle install to install gems inside the gemfile
RUN bundle install
