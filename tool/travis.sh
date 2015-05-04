#!/usr/bin/env bash

# Fast fail the script on failures.
set -e

# Verify that the libraries are error free.
pub global activate tuneup
pub global run tuneup check

# Verify code style.
# pub global activate linter
# pub global run linter ./

# Run the tests.
pub run test:test --reporter=expanded --no-color

# Install dart_coveralls; gather and send coverage data.
if [ "$COVERALLS_TOKEN" ] && [ "$TRAVIS_DART_VERSION" = "stable" ]; then
  pub global activate dart_coveralls
  pub global run dart_coveralls report \
    --token $COVERALLS_TOKEN \
    --retry 2 \
    --exclude-test-files \
    test/all.dart
fi