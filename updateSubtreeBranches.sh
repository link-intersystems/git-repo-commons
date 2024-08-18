#!/usr/bin/env bash

git subtree split -P gradle/.bin/ -b gradle/bin
git subtree split -P gradle/.github/ -b gradle/github

git remote set-url origin https://${PUSH_TOKEN}@github.com/link-intersystems/git-repo-commons.git
git fetch --all
git push origin +refs/heads/gradle/*:refs/heads/gradle/*