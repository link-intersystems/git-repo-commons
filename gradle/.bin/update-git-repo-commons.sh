#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PARENT_DIR="$(dirname "$SCRIPT_DIR")"

pushd $(pwd)
cd ${PARENT_DIR}

git subtree -P .bin pull --squash git-repo-commons gradle/bin
git subtree -P .github pull --squash git-repo-commons gradle/github

popd