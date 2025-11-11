#!/usr/bin/env bats

setup() {
  load helpers
  _common_setup
  cd $BATS_TEST_TMPDIR

  COMMANDS=("version" "new" "build" "run" "lint" "sync" "help")
}

@test '⚙ $(basename $BATS_TEST_FILENAME) K6_VERSION=$K6_VERSION; XK6_K6_REPO=$XK6_K6_REPO' {}

# bats test_tags=xk6:help,xk6:smoke,xk6:liveness
@test 'no args' {
  run $XK6
  [ $status -eq 0 ]
  echo "$output" | grep -q 'Use "xk6 \[command\] --help" for more information about a command.'
  for cmd in "${COMMANDS[@]}"; do
    echo "$output" | grep -q " $cmd "
  done
}

# bats test_tags=xk6:help,xk6:smoke,xk6:liveness
@test 'command --help' {
  for cmd in "${COMMANDS[@]}"; do
    run $XK6 $cmd --help
    [ $status -eq 0 ]
    echo "$output" | grep -q "xk6 $cmd"
  done
}
