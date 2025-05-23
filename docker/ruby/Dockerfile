ARG RUBY_VERSION=3.4.1

FROM ruby:$RUBY_VERSION-bookworm

ENV BUNDLE_PATH=/home/rails/bundle

# Run security updates and install apt-utils curl and locales
RUN bash -c "export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -qq && \
    echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen && \
    apt-get install -y apt-utils curl locales gnupg && \
    apt-get upgrade -y && apt-get clean"

# Install PostgreSQL client
RUN bash -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ bookworm-pgdg main' \
    > /etc/apt/sources.list.d/pgdg.list && \
    curl -sS https://www.postgresql.org/media/keys/ACCC4CF8.asc \
    | apt-key add - && apt-get update && \
    apt-get install -y --no-install-recommends postgresql-client-14"

# Install NodeJS
ARG NODE_VERSION=18.16.1
ARG YARN_VERSION=1.22.19
ENV PATH=/usr/local/node/bin:$PATH
RUN bash -c "curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
    /tmp/node-build-master/bin/node-build '$NODE_VERSION' /usr/local/node && \
    npm install -g yarn@$YARN_VERSION && \
    rm -rf /tmp/node-build-master"

# Install Bundler
ARG BUNDLER_VERSION=2.5.3
RUN bash -c "gem update --system && gem install bundler -v $BUNDLER_VERSION"

# Install Chromium and Chromium-Driver
RUN bash -c "apt-get install -y --no-install-recommends chromium chromium-driver"

# Copy entrypoint script that ensures gems and packages are installed
COPY ./docker-entrypoint.sh /bin/docker-entrypoint.sh

# Set working directory
WORKDIR /home/rails

# Create user and setup permissions
RUN bash -c "groupadd -r rails && \
    useradd --no-log-init -r -g rails -d /home/rails rails && \
    mkdir -p /home/rails/bundle && \
    mkdir -p /home/rails/bops-applicants/node_modules && \
    chown -R rails:rails /home/rails && \
    chmod go-rx /home/rails"

# Link chromedriver so the webdrivers gem finds it
RUN bash -c "mkdir -p /home/rails/.webdrivers && \
   ln -nfs /usr/bin/chromedriver /home/rails/.webdrivers/chromedriver && \
   /usr/bin/chromedriver --version | cut -d ' ' -f 2 | cat > /home/rails/.webdrivers/chromedriver.version"

# Create the crash reports directory - without it Chromium complains on startup
RUN bash -c "mkdir -p /home/rails/.config/chromium/Crash Reports/pending/ && \
    chown -R rails:rails /home/rails/.config"

# Switch to non-root user
USER rails:rails

ENTRYPOINT ["/bin/docker-entrypoint.sh"]
CMD ["/bin/bash"]
