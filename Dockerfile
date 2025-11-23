# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.4.7
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# Rails app lives here
WORKDIR /rails

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development test"


# Throw-away build stage to reduce size of final image
FROM base as build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential git libpq-dev libvips pkg-config libyaml-dev \
      zlib1g-dev libssl-dev libreadline-dev libffi-dev libxml2-dev libxslt1-dev

ENV NOKOGIRI_USE_SYSTEM_LIBRARIES=1

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v 2.7.2 && \
    bundle config set path ${BUNDLE_PATH} && \
    bundle config set without 'development test' && \
    bundle config set deployment 'true' && \
    bundle config set force_ruby_platform 'true' && \
    bundle install --jobs 4 --retry 3 --no-document && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile || true

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times (non-blocking)
RUN bundle exec bootsnap precompile app/ lib/ || true

# Adjust binfiles to be executable on Linux
RUN chmod +x bin/* && \
    sed -i "s/\r$//g" bin/* && \
    sed -i 's/ruby\.exe$/ruby/' bin/*

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile || true


# Final stage for app image
FROM base

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      curl libvips postgresql-client libyaml-0-2 libxml2 libxslt1.1 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy built artifacts: gems, application
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Ensure bundler environment and permissions for non-root user
ENV BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development test" \
    BUNDLE_DEPLOYMENT="1"

# Run and own only the runtime files as a non-root user for security
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails /usr/local/bundle db log storage tmp
USER rails:rails

RUN bundle config set path ${BUNDLE_PATH} && \
    bundle config set without 'development test' && \
    bundle config set deployment 'true' && \
    bundle check || bundle install --jobs 4 --retry 3 --no-document

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server"]
