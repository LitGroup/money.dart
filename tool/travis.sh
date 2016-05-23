#!/usr/bin/env bash

# Fast fail the script on failures.
set -e

printf "==> %s\n" "Install and run tuneup checks..."
pub global activate tuneup
pub global run tuneup check

printf "\n\n"
printf "==> %s\n" "Run tests..."
pub run test:test --reporter=expanded --no-color

# Verify code style.
# pub global activate linter
# pub global run linter ./

## Install dart_coveralls; gather and send coverage data.
#if [ "$COVERALLS_TOKEN" ] && [ "$TRAVIS_DART_VERSION" = "stable" ]; then
#  # Run tests with coverage checking.
#  # Install dart_coveralls; gather and send coverage data.
#  pub global activate dart_coveralls
#  pub global run dart_coveralls report \
#    --token $COVERALLS_TOKEN \
#    --retry 2 \
#    --exclude-test-files \
#    test/all.dart
#else
#  # Run the tests.
#  pub run test:test --reporter=expanded --no-color
#fi
