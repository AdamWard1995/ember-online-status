#!/bin/bash
function bump {
  git remote rm origin
  git remote add origin https://AdamWard1995:$GH_TOKEN@github.com/AdamWard1995/ember-online-status.git
  VERSION="$(npm view ember-online-status version)"

  git commit -m "Bump to version $VERSION"
  git push origin master

  API_JSON=$(printf '{"tag_name": "v%s","target_commitish": "master","name": "v%s","body": "Release of version %s","draft": false,"prerelease": false}' $VERSION $VERSION $VERSION)
  curl --data "$API_JSON" https://api.github.com/repos/AdamWard1995/ember-online-status/releases?access_token=$GH_TOKEN
  npm run ci-publish || true
}

if [ "$TRAVIS_PULL_REQUEST" = "false" ]; then
  if [[ $TRAVIS_COMMIT_MESSAGE == *"[ci patch]"* ]]; then
    npm version patch
    bump
  fi
  if [[ $TRAVIS_COMMIT_MESSAGE == *"[ci minor]"* ]]; then
    npm version minor
    bump
  fi
  if [[ $TRAVIS_COMMIT_MESSAGE == *"[ci major]"* ]]; then
    npm version major
    bump
  fi
fi
