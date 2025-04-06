#!/usr/bin/env bats

setup() {
  load helpers
  _common_setup
  cd $BATS_TEST_TMPDIR
}

_test_k6_with_version() {
  unset K6_VERSION
  run $XK6 build $1 --with $IT_MOD=$IT_DIR --with $EXT_MOD/base32=$EXT_DIR/base32
  [ $status -eq 0 ]
  echo "$output" | grep -q "xk6 has now produced a new k6 binary"
  ./k6 version | grep -q "k6/x/it/base32"
  ./k6 run $EXT_DIR/base32/script.js | grep -q '✓ base32'

  if [ -n "$2" ]; then
    ./k6 version | grep -q "$2"
  fi
}

# bats test_tags=xk6:non-semver,xk6:build,xk6:smoke
@test 'latest' {
  _test_k6_with_version latest $K6_LATEST_VERSION
}

# bats test_tags=xk6:non-semver,xk6:build,xk6:smoke
@test 'master' {
  _test_k6_with_version master
}

# bats test_tags=xk6:non-semver,xk6:build,xk6:smoke
@test 'hash' {
  export GOPRIVATE="go.k6.io/k6"

  _test_k6_with_version $K6_OTHER_VERSION_HASH $K6_OTHER_VERSION
}
