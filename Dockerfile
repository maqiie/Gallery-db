# -------------------------------
# Base image
# -------------------------------
FROM ruby:3.3.5-slim-bullseye

# -------------------------------
# Environment variables
# -------------------------------
ENV RAILS_ENV=production \
    RACK_ENV=production \
    BUNDLER_VERSION=2.5.21 \
    LANG=C.UTF-8 \
    TZ=Africa/Nairobi

# -------------------------------
# Install system dependencies
# -------------------------------
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
      tzdata && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# -------------------------------
# Install Bundler
# -------------------------------
RUN gem install bundler -v $BUNDLER_VERSION

# -------------------------------
# Set working directory
# -------------------------------
WORKDIR /app

# -------------------------------
# Copy Gemfiles and install gems
# -------------------------------
COPY Gemfile Gemfile.lock ./
RUN bundle config set deployment 'true' && \
    bundle install --jobs 4 --retry 3 --without development test

# -------------------------------
# Copy the rest of the application
# -------------------------------
COPY . .

# -------------------------------
# Precompile assets (if using Rails assets)
# -------------------------------
RUN bin/rails assets:precompile

# -------------------------------
# Expose port
# -------------------------------
EXPOSE 3000

# -------------------------------
# Start Rails server
# -------------------------------
CMD ["bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]
