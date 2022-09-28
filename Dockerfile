FROM circleci/ruby:2.7.2-buster-node-browsers

USER root

# Install latest Bundler
RUN gem install bundler --no-doc

# Add Postgres
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main"
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# Common dependencies
RUN apt-get update -qq --allow-releaseinfo-change \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    software-properties-common \
    gcc \
    g++ \
    make \
    qt5-default \
    libqt5webkit5-dev \
    ruby-dev \
    zlib1g-dev \
    pdftk \
    postgresql-client \
    libqtwebkit-dev \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

# Create app directory and copy source
WORKDIR /app
COPY . .

# Install app dependencies
RUN bundle config set pa flag vendor/bundle
RUN yarn install --check-files
RUN bundle install --jobs=3 --retry=3

EXPOSE 3000