#!/bin/bash
export
# Update docs only on 'master' changes (and only for ruby 2.3)
[ "$TRAVIS_RUBY_VERSION" === "2.3.0" ] || exit 0
[ "$TRAVIS_BRANCH" == "master" ] || exit 0
[ "$TRAVIS_EVENT_TYPE" == "push" ] || exit 0 # after apply PR
rake yard:build
git add -f ./doc
git config user.name "Travis CI"
git config user.email "$TRAVIS_EMAIL"
git commit -m 'Update docs'
echo machine github.com > ~/.netrc
echo login $TRAVIS_GITHUB_ACCOUNT >> ~/.netrc
echo password $TRAVIS_GITHUB_TOKEN >> ~/.netrc

# Publish to github
rake yard:publish
