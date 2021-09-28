FROM ruby:2.7.4

RUN gem install bundler:2.2.20

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

# Update & install node
RUN apt-get update
RUN apt-get install -y nodejs

# Install Chromium for integration tests
RUN apt-get install -y --no-install-recommends chromium

# Install yarn
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install yarn

# Bundle gems in a separate folder for better Docker caching
WORKDIR /gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Same with JS dependencies
WORKDIR /js
COPY package.json yarn.lock ./
RUN yarn install --modules-folder=/app/node_modules

WORKDIR /app
COPY . .

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
