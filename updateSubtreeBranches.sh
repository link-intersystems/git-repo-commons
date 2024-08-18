#!/usr/bin/env bash

git remote set-url origin https://${PUSH_TOKEN}@github.com/link-intersystems/git-repo-commons.git
git fetch -f --all

git branch gradle/bin git-repo-commons/gradle/bin
git subtree split -P gradle/.bin/ -b gradle/bin

git branch gradle/github git-repo-commons/gradle/github
git subtree split -P gradle/.github/ -b gradle/github

git push origin refs/heads/gradle/*:refs/heads/gradle/*