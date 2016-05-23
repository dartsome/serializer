#!/bin/bash

# Fast fail the script on failures.
set -e

# Verify that the libraries are error free
dartanalyzer --fatal-warnings \
  lib/*.dart \
  lib/src/*.dart \
  lib/codecs/*.dart \
  test/*_test.dart

TESTS="test/json_test.dart test/typed_json_test.dart test/double_json_test.dart"
# Run vm tests
pub run test -p vm ${TESTS}

# Run browser tests
export DISPLAY=:99.0
sh -e /etc/init.d/xvfb start
pub serve &
while ! nc -z localhost 8080; do sleep 1; done; echo 'pub serve is up!'
pub run test --pub-serve=8080 -p content-shell -p firefox ${TESTS}

# Install dart_coveralls
# Gather and send coverage data.
# Force 1.15.0: https://github.com/duse-io/dart-coveralls/issues/55
if [ "${COVERALLS_TOKEN}" ] && [ "${TRAVIS_DART_VERSION}" = "1.15.0" ]; then
  pub global activate dart_coveralls
  pub global run dart_coveralls report \
    --exclude-test-files \
    ${TESTS}
fi
