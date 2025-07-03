FROM ruby:2.7

# Install essential dependencies
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

# Copy project files
COPY . .

# ✅ Ensure `run` is executable
RUN chmod +x ./run

# ✅ Create log and tmp directories with proper ownership
RUN mkdir -p log tmp && \
    useradd -u 1000 -m -r judge0 && \
    echo "judge0 ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers && \
    chown -R judge0:judge0 /app/log /app/tmp

# ✅ Install Ruby dependencies
RUN gem install bundler:2.1.4 && \
    bundle install

# Optional: Install global Node packages
RUN npm install -g aglio@2.3.0

EXPOSE 2358

USER judge0

# ✅ Start the app via custom script
CMD ["sh", "./run"]
