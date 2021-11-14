ARG RUBY_VERSION
FROM ruby:${RUBY_VERSION}-alpine

RUN apk add --no-cache --update build-base \
  bash \
  git \
  postgresql-dev \
  imagemagick \
  vips \
  tzdata \
  && rm -rf /var/cache/apk/*

WORKDIR /app

COPY Gemfile* ./

RUN gem update --system
RUN bundle install -j $(nproc)
