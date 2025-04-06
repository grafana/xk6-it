#!/usr/bin/env bats

setup() {
  load helpers
  _common_setup
  cd $BASEDIR
}

@test '⚙ K6_VERSION=$K6_VERSION; XK6_K6_REPO=$XK6_K6_REPO' {}

# bats test_tags=xk6:run,xk6:smoke
@test 'no arg' {
  run $XK6 run script.js
  [ $status -eq 0 ]
  echo "$output" | grep -q '✓ it'
}

# bats test_tags=xk6:run
@test 'subdirectory' {
  check_xk6_version
  cd test

  run $XK6 run ../script.js
  [ $status -eq 0 ]
  echo "$output" | grep -q '✓ it'
}

# bats test_tags=xk6:run
@test '--with module=local' {
  check_xk6_version
  cd $EXT_DIR/base32

  run $XK6 run --with $IT_MOD=$IT_DIR script.js
  [ $status -eq 0 ]
  echo "$output" | grep -q '✓ base32'
}

# bats test_tags=xk6:run
@test '--with module' {
  check_xk6_version
  cd $EXT_DIR/base32

  run $XK6 run --with $IT_MOD@$IT_VER script.js
  [ $status -eq 0 ]
  echo "$output" | grep -q '✓ base32'
}
