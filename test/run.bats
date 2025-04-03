#!/usr/bin/env bats

setup() {
  load helpers
  _common_setup
  cd $BASEDIR
}

@test '⚙ K6_VERSION=$K6_VERSION; K6_REPO=$K6_REPO' {}

@test 'no arg' {
  run $XK6 run script.js
  [ $status -eq 0 ]
  echo "$output" | grep -q '✓ it'
}

@test 'subdirectory' {
  check_xk6_version
  cd test

  run $XK6 run ../script.js
  [ $status -eq 0 ]
  echo "$output" | grep -q '✓ it'
}

@test '--with module=local' {
  check_xk6_version
  cd $EXT_DIR/base32

  run $XK6 run --with $IT_MOD=$IT_DIR script.js
  [ $status -eq 0 ]
  echo "$output" | grep -q '✓ base32'
}

@test '--with module' {
  check_xk6_version
  cd $EXT_DIR/base32

  run $XK6 run --with $IT_MOD@$IT_VER script.js
  [ $status -eq 0 ]
  echo "$output" | grep -q '✓ base32'
}
