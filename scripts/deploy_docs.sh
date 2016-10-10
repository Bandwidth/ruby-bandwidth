#!/bin/bash
# Update docs only on 'master' changes (only for ruby 2.3 build)
[[ $TRAVIS_RUBY_VERSION =~ ^2\.3\..* ]] || exit 0
[ "$TRAVIS_BRANCH" == "master" ] || exit 0
[ "$TRAVIS_EVENT_TYPE" == "push" ] || exit 0 # after apply PR


# Publish to github
git config user.name "Travis CI"
git config user.email "$TRAVIS_EMAIL"
echo machine github.com > ~/.netrc
echo login $TRAVIS_GITHUB_ACCOUNT >> ~/.netrc
echo password $TRAVIS_GITHUB_TOKEN >> ~/.netrc

rake yard:publish
