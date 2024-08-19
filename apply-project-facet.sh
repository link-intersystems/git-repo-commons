#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

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

function updateSubtree(){
  local repo=$1
  local projectFacet=$2
  local subtree=$3
  local existingSubtrees=$(git log | grep git-subtree-dir | tr -d ' ' | cut -d ":" -f2 | sort | uniq | xargs -I {} bash -c 'if [ -d $(git rev-parse --show-toplevel)/{} ] ; then echo {}; fi')
  local subtreeBranchQualifier="${subtree#\.}"

  if [[ ${existingSubtrees} =~ ${subtree} ]]; then
    git subtree -P "${subtree}" pull --squash "${repo}" "${projectFacet}/${subtreeBranchQualifier}"
  else
    local subtreeBranchQualifier="${subtree#\.}"
    git subtree -P "${subtree}" add --squash "${repo}/${projectFacet}/${subtreeBranchQualifier}"
  fi
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

  updateSubtree "${repo}" "${projectFacet}" ".bin"
  updateSubtree "${repo}" "${projectFacet}" ".github"
}


main "$@"; exit