#!/usr/bin/env bash

main() {
  local projectFacet="${1:-gradle}"
  onGitRootDir applyProjectFacet "git-repo-commons" "${projectFacet}"
}

function onGitRootDir() {
  pushd "$(pwd)" > /dev/null
  cd "$(git rev-parse --show-toplevel)"
  local command=$1
  shift
  $command $*
  popd > /dev/null
}

function applyProjectFacet() {
  local repo="$1"
  local projectFacet="$2"

  echo "Applying project facet ${projectFacet}"

  if [ -z "$(git remote | grep "${repo}")" ]; then
    echo "Adding Repository ${repo}"
    git remote add ${repo} https://github.com/link-intersystems/${repo}.git
  fi

  echo "Fetching refs/remotes/${repo}/${projectFacet}/*"
  git fetch ${repo} +refs/heads/${projectFacet}/*:refs/remotes/${repo}/${projectFacet}/*

  source <(curl -H 'Cache-Control: no-cache, no-store' -s https://raw.githubusercontent.com/link-intersystems/git-repo-commons/main/${projectFacet}/.bin/git_utils)

  updateSubtree "${repo}" "${projectFacet}" ".bin"
  updateSubtree "${repo}" "${projectFacet}" ".github"
}


main "$@"; exit