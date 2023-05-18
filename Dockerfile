FROM ruby:3.2.1

RUN gem install bundler:2.3.5

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

# Update the system
RUN apt-get update -y

# Install Chromium for integration tests
RUN apt-get install -y --no-install-recommends chromium

# Bundle gems in a separate folder for better Docker caching
WORKDIR /gems
COPY Gemfile Gemfile.lock .ruby-version ./
RUN bundle install

## Node
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y nodejs

# Install yarn
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install yarn

# Same with JS dependencies
WORKDIR /js
COPY package.json yarn.lock ./
RUN yarn install --modules-folder=/app/node_modules

WORKDIR /app
COPY . .

CMD ["bundle", "exec", "bin/dev"]
