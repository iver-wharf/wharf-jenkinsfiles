#!/usr/bin/env bash

set -euo pipefail

: ${VARS_FILE:?"Missing vars.env file"}

# Source the .env file with `export MY_ENV_VAR=...`
. <(sed 's/^\([a-zA-Z0-9_]*=\)/export \1/' "$VARS_FILE")

# Enforces only ${MY_ENV_VAR} formatting and not $MY_ENV_VAR,
# as well as only perform var-sub on vars found in the VARS_FILE
ENVSUBST_SHELL_FORMAT="$(sed 's/^\([a-zA-Z_][a-zA-Z0-9_]*\).*$/${\1}/' "$VARS_FILE")"

replaceVariables() {
	for FILE in $(git ls-files)
	do
		cat "${FILE}" | envsubst "$ENVSUBST_SHELL_FORMAT" > "${FILE}.tmp"
		mv "${FILE}.tmp" "${FILE}"
	done
	git add .
	git commit --allow-empty -m "Replaced env variables"
}

{
	cd /var/www/html/git/build.git
	for BRANCH in $(git branch -a --format '%(refname:short)')
	do
		git reset --hard
		git checkout "$BRANCH"
		replaceVariables
	done
}

{
	cd /var/www/html/git/seed.git
	replaceVariables
}

chown -R www-data:www-data /var/www/html/git
chmod -R 555 /var/www/html/git
