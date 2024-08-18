#!/usr/bin/env bash

main() {
  onGitRootDir applyProjectFacet "git-repo-commons" "${1:-gradle}"
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

  addSubtree ".bin"
  addSubtree ".github"
}

function addSubtree(){
  local subtree=$1
  local existingSubtrees=$(git log | grep git-subtree-dir | tr -d ' ' | cut -d ":" -f2 | sort | uniq | xargs -I {} bash -c 'if [ -d $(git rev-parse --show-toplevel)/{} ] ; then echo {}; fi')

  if [[ ! ${existingSubtrees} =~ ${subtree} ]]; then
    local subtreeBranchQualifier="${subtree#\.}"
    git subtree -P "${subtree}" add --squash "${repo}/${projectFacet}/${subtreeBranchQualifier}"
  fi
}

main "$@"; exit