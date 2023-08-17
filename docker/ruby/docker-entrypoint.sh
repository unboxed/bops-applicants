#!/bin/bash

set -e
echo "Initializing BOPS applicants"

echo "Installing yarn"
yarn install

export BUNDLE_PATH=/home/rails/bundle
echo "Bundling gems"
bundle check || bundle install

if [ "$1" = "bash" ]; then
  exec "$@"
else
  bundle exec "$@"
fi
