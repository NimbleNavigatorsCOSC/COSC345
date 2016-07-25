#!/bin/bash

# Fast fail the script on failures
set -e

# Verify everything is error and warning-free
echo "Running dartanalyzer..."
dartanalyzer $DARTANALYZER_FLAGS \
  lib/alarm_clock_app.dart \
  lib/emulator.dart \ 
  lib/hello.dart \
  lib/hello_world_app.dart \
  lib/src/emulator/emulator.dart \
  lib/src/emulator/emulator_application.dart \
  lib/src/emulator/emulator_screen.dart \
  web/assets/dart/alarm_clock.dart \
  web/assets/dart/desanitize_emails.dart \
  web/assets/dart/hello_world.dart

# Run the vm tests
echo "Running VM tests..."
pub run test -p vm

# Run the browser tests
echo "Running Browser tests..."
export DISPLAY=:99.0
sh -e /etc/init.d/xvfb start
pub serve test &
while ! nc -z localhost 8080; do sleep 1; done; echo 'pub serve is up!'
pub run test --pub-serve=8080 -p content-shell -p firefox

# Install dart_coveralls; gather and send coverage data
# Only on 1.15.0 as dart_coveralls fails starting 1.16.0
if [ "$COVERALLS_TOKEN" ] && [ "$TRAVIS_DART_VERSION" = "1.15.0" ]; then
    echo "Running coverage..."
    pub global activate dart_coveralls
    pub global run dart_coveralls report \
        --retry 2 \
        --exclude-test-files \
        --debug \
        test/test_all.dart
fi