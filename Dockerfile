FROM ruby:2.7

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      cron \
      libpq-dev \
      sudo \
      nodejs \
      npm && \
    rm -rf /var/lib/apt/lists/*

ENV GEM_HOME="/usr/local/bundle"
ENV PATH="$GEM_HOME/bin:$PATH"

WORKDIR /app

# Copy code before installing gems
COPY . .

# Create judge0 user before permission setup
RUN useradd -u 1000 -m -r judge0

# ✅ Create needed dirs + fix permissions
RUN mkdir -p /app/tmp /app/log && \
    chown -R judge0:judge0 /app

# ✅ Install bundler + all gems before switching users
RUN gem install bundler:2.1.4 && \
    bundle config set --local path 'vendor/bundle' && \
    bundle install

# Optional: Install global Node packages
RUN npm install -g aglio@2.3.0

# ✅ Make run script executable
RUN chmod +x ./run

EXPOSE 3000

# ✅ Switch user AFTER all setup
USER judge0

CMD ["sh", "./run"]
