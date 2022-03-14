#!/usr/bin/env bash

set -euo pipefail

: ${GIT_USER_NAME:="git"}
: ${GIT_USER_PASS:=""}

htpasswd -cb /var/www/html/git/htpasswd "${GIT_USER_NAME}" "${GIT_USER_PASS}"
