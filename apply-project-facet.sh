#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )


main() {
  local projectFacet="${1:-gradle}"

  installProjectFacet "${projectFacet}"
}



function installProjectFacet() {
  local projectFacet="$1"

  importGitBinScript "${projectFacet}" git_utils
  local binHead=$(git fetch --porcelain  https://github.com/link-intersystems/git-repo-commons.git ${projectFacet}/bin | awk '{ print $3 }')
  local projectFacetScriptId=$(git ls-tree ${binHead} project-facet | awk '{ print $3 }')

  cat <(git cat-file -p ${projectFacetScriptId}) | bash -s -- install "${projectFacet}"
}

function importGitBinScript() {
  local projectFacet="$1"
  local scriptpath="$2"

  local binHead=$(git fetch --porcelain  https://github.com/link-intersystems/git-repo-commons.git ${projectFacet}/bin | awk '{ print $3 }')
  local gitUtilsObjectId=$(git ls-tree ${binHead} ${scriptpath} | awk '{ print $3 }')

  source <(git cat-file -p ${gitUtilsObjectId})
}




main "$@"; exit