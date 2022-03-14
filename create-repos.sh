#!/usr/bin/env bash

set -euo pipefail

: ${SRC_DIR:="/root/src"}
: ${REPO_DIR:="/var/www/html/git"}

git config --global user.name "wharf-jenkinsfiles"
git config --global user.email "wharf-jenkinsfiles@iver-wharf.github.com"
git config --global init.defaultBranch master

{
	mkdir -pv "$REPO_DIR/build.git"
	cd "$REPO_DIR/build.git"
	git init

	for BUILD_BRANCH in $(ls "$SRC_DIR/build.git")
	do
		git checkout -b "$BUILD_BRANCH"
		cp -v "$SRC_DIR/build.git/$BUILD_BRANCH/Jenkinsfile" .
		git add .
		git commit -m "Added $BUILD_BRANCH/Jenkinsfile"
		echo "Added branch: '$BUILD_BRANCH'"
	done

	git checkout -b master
	git commit --allow-empty -m "Initial commit"
	git update-server-info
}

{
	mkdir -pv "$REPO_DIR/seed.git"
	cd "$REPO_DIR/seed.git"
	git init

	git checkout -b master
	mkdir -pv jobs
	cp -v "$SRC_DIR"/seed.git/jobs/* jobs/
	git add .
	git commit -m "Added seed pipelines"

	git update-server-info
}
