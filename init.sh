#!/usr/bin/env bash

REPO_TYPE=${1:=gradle}

git remote add git-repo-commons https://github.com/link-intersystems/git-repo-commons.git
git remote set-branches git-repo-commons "${REPO_TYPE}"'/*'
git fetch git-repo-commons

git subtree -P .bin add --squash git-repo-commons/${REPO_TYPE}/bin
git subtree -P .github add --squash git-repo-commons/${REPO_TYPE}/workflows
