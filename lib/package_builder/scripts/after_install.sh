#!/usr/bin/env bash
set -e
set -o pipefail

chown -R deploy:deploy /home/deploy/bops-applicants/releases/<%= release %>

su - deploy <<'EOF'
ln -nfs /home/deploy/bops-applicants/shared/tmp /home/deploy/bops-applicants/releases/<%= release %>/tmp
ln -nfs /home/deploy/bops-applicants/shared/log /home/deploy/bops-applicants/releases/<%= release %>/log
ln -nfs /home/deploy/bops-applicants/shared/bundle /home/deploy/bops-applicants/releases/<%= release %>/vendor/bundle
ln -nfs /home/deploy/bops-applicants/shared/packs /home/deploy/bops-applicants/releases/<%= release %>/public/packs
ln -s /home/deploy/bops-applicants/releases/<%= release %> /home/deploy/bops-applicants/current_<%= release %>
mv -Tf /home/deploy/bops-applicants/current_<%= release %> /home/deploy/bops-applicants/current
cd /home/deploy/bops-applicants/current && bundle install --without development test --deployment --quiet
cd /home/deploy/bops-applicants/current && bundle exec rake assets:precompile
EOF
