#!/bin/bash
function bump {
  echo "Configuring git..."
  git config user.name "Travis CI"
  git config user.email "adam.ward@carleton.ca"
  git remote rm origin
  git remote add origin https://AdamWard1995:$GH_TOKEN@github.com/AdamWard1995/ember-online-status.git
  git reset --hard HEAD

  echo "Bumping version..."
  VERSION="$(npm version $1 --force -m 'Bump to version %s')"
  COMMIT="$(git log -1)"
  echo "Git commit: $COMMIT"

  echo "Pushing version changes..."
  git push origin master

  echo "Creating new release..."
  API_JSON=$(printf '{"tag_name": "%s","target_commitish": "master","name": "%s","body": "Release of version %s","draft": false,"prerelease": false}' $VERSION $VERSION $VERSION)
  curl --data "$API_JSON" https://api.github.com/repos/AdamWard1995/ember-online-status/releases?access_token=$GH_TOKEN

  echo "Publishing to NPM..."
  npm run ci-publish || true

  exit 0
}

if [ "$TRAVIS_PULL_REQUEST" = "false" ] && [ "$TRAVIS_NODE_VERSION" != "6.11.0" ] && [ "$EMBER_TRY_SCENARIO" != "ember-default" ]; then
  echo "Starting deployment process..."
  if [[ $TRAVIS_COMMIT_MESSAGE == *"[ci patch]"* ]]; then
    echo "Running patch release..."
    bump "patch"
    exit 1
  fi
  if [[ $TRAVIS_COMMIT_MESSAGE == *"[ci minor]"* ]]; then
    echo "Running minor release..."
    bump "minor"
    exit 1
  fi
  if [[ $TRAVIS_COMMIT_MESSAGE == *"[ci major]"* ]]; then
    echo "Running major release..."
    bump "major"
    exit 1
  fi
fi
