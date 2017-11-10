#!/bin/bash
function bump {
  VERSION=$(npm version $1 -m "Bump to version %s")
  if git rev-parse "$VERSION" >/dev/null 2>&1; then
    git remote rm origin
    git remote add origin https://AdamWard1995:$GH_TOKEN@github.com/AdamWard1995/ember-online-status.git
    git push origin master

    API_JSON=$(printf '{"tag_name": "%s","target_commitish": "master","name": "%s","body": "Release of version %s","draft": false,"prerelease": false}' $VERSION $VERSION $VERSION)
    curl --data "$API_JSON" https://api.github.com/repos/AdamWard1995/ember-online-status/releases?access_token=$GH_TOKEN
    npm run ci-publish || true
  fi
}

if [ "$TRAVIS_PULL_REQUEST" = "false" ]; then
  if [[ $TRAVIS_COMMIT_MESSAGE == *"[ci patch]"* ]]; then
    bump patch
  fi
  if [[ $TRAVIS_COMMIT_MESSAGE == *"[ci minor]"* ]]; then
    bump minor
  fi
  if [[ $TRAVIS_COMMIT_MESSAGE == *"[ci major]"* ]]; then
    bump major
  fi
fi
