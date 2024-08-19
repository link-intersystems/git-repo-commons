#!/usr/bin/env bash

main() {
  local projectFacet="${1:-gradle}"

  installProjectFacet "${projectFacet}"
}


function installProjectFacet() {
  local projectFacet="$1"

  local binHead=$(git fetch --porcelain https://github.com/link-intersystems/git-repo-commons.git ${projectFacet}/bin | awk '{ print $3 }')
  local projectFacetScriptId=$(git ls-tree ${binHead} project-facet | awk '{ print $3 }')

  cat <(git cat-file -p ${projectFacetScriptId}) | bash -s -- install "${projectFacet}"
}


main "$@"; exit