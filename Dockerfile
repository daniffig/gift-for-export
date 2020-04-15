# https://medium.com/magnetis-backstage/how-to-cache-bundle-install-with-docker-7bed453a5800

ARG RUBY_VERSION
FROM ruby:$RUBY_VERSION-alpine

RUN apk update -qq 
RUN apk add -q build-base nodejs tzdata yarn python

ARG BUNDLER_VERSION
RUN gem update --system
RUN gem install bundler:$BUNDLER_VERSION

ENV app /app
RUN mkdir -p $app
WORKDIR $app

COPY Gemfile .
COPY Gemfile.lock .

ARG BUNDLE_PATH
RUN bundle install $BUNDLEPATH --jobs 4 --retry 3

ADD . $app

# RUN yarn install --check-files
RUN yarn install

RUN bundle exec rake assets:precompile

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
