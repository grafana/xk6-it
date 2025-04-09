#!/usr/bin/env bats

setup() {
  load $BATS_TEST_DIRNAME/../../test/helpers
  _common_setup
}

@test 'Run script.js' {
  check_xk6_version
  cd $BATS_TEST_DIRNAME
  run $XK6 run --with $IT_MOD=../.. script.js
  [ $status -eq 0 ]
  echo "$output" | grep -q '✓ sha1'
}
