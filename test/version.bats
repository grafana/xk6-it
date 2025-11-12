#!/usr/bin/env bats

setup() {
  load helpers
  _common_setup
  cd $BATS_TEST_TMPDIR
}

@test '⚙ $(basename $BATS_TEST_FILENAME) K6_VERSION=$K6_VERSION; XK6_K6_REPO=$XK6_K6_REPO' {}

# bats test_tags=xk6:version,xk6:smoke,xk6:liveness
@test 'no args' {
  run $XK6 version
  [ $status -eq 0 ]
  echo "$output" | egrep -q '^xk6 version [^[:space:]]+$'
}

# bats test_tags=xk6:version,xk6:smoke,xk6:liveness
@test '--version' {
  run $XK6 --version
  [ $status -eq 0 ]
  echo "$output" | egrep -q '^xk6 version [^[:space:]]+$'
}

# bats test_tags=xk6:version,xk6:smoke,xk6:liveness
@test 'specific version: $XK6_VERSION' {
  if [[ -z "$XK6_VERSION" ]]; then
    skip "XK6_VERSION is not set"
  fi

  run $XK6 version
  [ $status -eq 0 ]
  echo "$output" | grep -q "^xk6 version ${XK6_VERSION}\$"
}
