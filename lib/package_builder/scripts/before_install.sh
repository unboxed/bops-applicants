#!/usr/bin/env bash
set -e
set -o pipefail

su - deploy <<'EOF'
rm -rf /home/deploy/bops-applicants/current/.bundle
rm -f /home/deploy/bops-applicants/current/log
rm -f /home/deploy/bops-applicants/current/tmp
rm -f /home/deploy/bops-applicants/current/vendor/bundle
rm -f /home/deploy/bops-applicants/current/public/packs
rm -rf /home/deploy/bops-applicants/current/node_modules
EOF
