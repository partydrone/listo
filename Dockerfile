FROM ruby:3.2.0-slim-bullseye AS build

ARG UID=1000
ARG GID=1000

WORKDIR /srv

RUN bash -c "set -o pipefail && apt-get update \
  && apt-get update && apt-get install -y --no-install-recommends build-essential curl git libpq-dev \
  && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
  && apt-get clean \
  && groupadd -g \"${GID}\" ruby \
  && useradd --create-home --no-log-init -u \"${UID}\" -g \"${GID}\" ruby \
  && mkdir /node_modules && chown ruby:ruby -R /node_modules /srv"

USER ruby

COPY --chown=ruby:ruby Gemfile* ./
RUN bundle install -j $(nproc)

ARG RAILS_ENV=production
ENV RAILS_ENV=${RAILS_ENV} \
  PATH=${PATH}:/home/ruby/.local/bin \
  USER=ruby

COPY --chown=ruby:ruby . .

RUN if [ ${RAILS_ENV} != "development" ]; then \
  SECRET_KEY_BASE=dummyvalue rails assets:precompile; fi

CMD ["bash"]

################################################################################

FROM ruby:3.2.0-slim-bullseye AS app

WORKDIR /srv

ARG UID=1000
ARG GID=1000

RUN apt-get update \
  && apt-get install -y --no-install-recommends build-essential curl libpq-dev \
  && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
  && apt-get clean \
  && groupadd -g "${GID}" ruby \
  && useradd --create-home --no-log-init -u "${UID}" -g "${GID}" ruby \
  && chown ruby:ruby -R /srv

USER ruby

COPY --chown=ruby:ruby bin/ ./bin
RUN chmod 0755 bin/*

ARG RAILS_ENV=production
ENV RAILS_ENV=production \
  PATH=${PATH}:/home/ruby/.local/bin \
  USER=ruby

COPY --chown=ruby:ruby --from=build /usr/local/bundle /usr/local/bundle
COPY --chown=ruby:ruby --from=build /srv/public /public
COPY --chown=ruby:ruby . .

EXPOSE 3000

CMD ["rails", "s"]
