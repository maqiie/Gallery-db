# ==== Base Image ====
FROM ruby:3.3.5-slim-bookworm

ENV LANG=C.UTF-8 \
    RAILS_ENV=production \
    NODE_ENV=production \
    BUNDLE_JOBS=4 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT="development test"

# ==== Install Dependencies ====
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

# ==== Install Bundler ====
RUN gem install bundler -v 2.5.21

# ==== Set Workdir ====
WORKDIR /app

# ==== Copy Gemfiles & Install Gems ====
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --retry 3

# ==== Copy the App ====
COPY . .

# ==== Precompile Assets ====
RUN bin/rails assets:precompile

# ==== Expose Port ====
EXPOSE 8080

# ==== Start Command ====
CMD ["bin/rails", "server", "-b", "0.0.0.0", "-p", "8080"]
