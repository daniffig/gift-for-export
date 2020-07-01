# https://medium.com/magnetis-backstage/how-to-cache-bundle-install-with-docker-7bed453a5800
# https://gist.github.com/zentetsukenz/5e330b801f983e3d39757686dcb41cc2

FROM ruby:2.6.5-alpine AS base
ENV RAILS_APP /usr/local/app
RUN apk update -qq && apk add -q build-base tzdata
RUN gem update --system
RUN gem install bundler:2.1.4
WORKDIR /tmp
COPY Gemfile Gemfile.lock /tmp/
RUN bundle install --jobs 4 --retry 3
WORKDIR /usr/local/app
COPY . /usr/local/app

# nodejs
FROM base AS nodejs
RUN apk add -q nodejs python yarn
RUN yarn install --no-lockfile --production \
    && bundle exec rake webpacker:compile RAILS_ENV=production

# production
FROM base AS production
RUN rm -rf ./node_modules ./public/packs ./tmp /tmp/* \
    && bundle exec rake tmp:create
COPY --from=nodejs "$RAILS_APP/public/packs" "$RAILS_APP/public/packs"
EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]