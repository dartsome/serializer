#!/bin/bash

# Kill jobs
trap 'kill $(jobs -pr)' SIGINT SIGTERM EXIT

# Fast fail the script on failures.
set -e


if  [ "${TRAVIS_DART_VERSION}" != "1.15.0" ]; then
# Verify that the libraries are error free
dartanalyzer --strong --fatal-warnings \
  lib/*.dart \
  lib/core/*.dart \
  lib/codegen/*.dart \
  lib/reflectable/*.dart \
  lib/codecs/*.dart \
  test/*_test.dart
fi

#Generate Codecs
pub run tool/build.dart

TESTS="test/reflectable/codecs_test.dart \
           test/reflectable/double_json_test.dart \
           test/reflectable/json_test.dart \
           test/reflectable/typed_json_test.dart \
           test/codegen/all_test.dart"

# Run vm tests
pub run test -p vm ${TESTS}

# Run browser tests
if [ "${TRAVIS}" == "true" ]; then
  export DISPLAY=:99.0
  sh -e /etc/init.d/xvfb start
fi
pub serve test &
while ! nc -z localhost 8080; do sleep 1; done; echo 'pub serve is up!'
pub run test --pub-serve=8080 -p firefox ${TESTS}

# Install dart_coveralls
# Gather and send coverage data.
# Force 1.15.0: https://github.com/duse-io/dart-coveralls/issues/55
if [ "${COVERALLS_TOKEN}" ] && [ "${TRAVIS_DART_VERSION}" = "1.15.0" ]; then
  pub global activate dart_coveralls
  pub global run dart_coveralls report \
    --exclude-test-files \
    test/reflectable/codecs_test.dart \
    test/reflectable/double_json_test.dart \
    test/reflectable/json_test.dart \
    test/reflectable/typed_json_test.dart \
    test/codegen/all_test.dart
fi
