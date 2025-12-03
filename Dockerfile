FROM ruby:3.3.5-slim-bullseye

ENV RAILS_ENV=production \
    RACK_ENV=production \
    BUNDLER_VERSION=2.5.21 \
    LANG=C.UTF-8 \
    TZ=Africa/Nairobi

# Install system dependencies including libssl3
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      build-essential \
      libvips-dev \
      libpq-dev \
      nodejs \
      yarn \
      git \
      curl \
      imagemagick \
      ca-certificates \
      tzdata \
      libssl3 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN gem install bundler -v $BUNDLER_VERSION

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle config set deployment 'true' && \
    bundle install --jobs 4 --retry 3 --without development test

COPY . .

# Precompile assets
RUN bin/rails assets:precompile

EXPOSE 3000

CMD ["bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]
