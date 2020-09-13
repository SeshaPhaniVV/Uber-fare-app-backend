FROM ruby:alpine

RUN apk update && apk add bash build-base nodejs postgresql-dev tzdata

RUN mkdir /project
WORKDIR /project

COPY Gemfile* ./
RUN gem install bundler --no-document
RUN bundle install --no-binstubs --jobs $(nproc) --retry 3

COPY . /project/

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]