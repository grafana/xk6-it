#!/usr/bin/env bats

setup() {
  load helpers
  _common_setup
  cd $BATS_TEST_TMPDIR
}

@test '⚙ $(basename $BATS_TEST_FILENAME) K6_VERSION=$K6_VERSION; XK6_K6_REPO=$XK6_K6_REPO' {}

# bats test_tags=xk6:build,xk6:smoke
@test 'no args' {
  run $XK6 build
  [ $status -eq 0 ]
  echo "$output" | grep -q "xk6 has now produced a new k6 binary"
  ./k6 version
}

# bats test_tags=xk6:build,xk6:smoke
@test 'version arg' {
  VERSION=$K6_VERSION
  unset K6_VERSION

  run $XK6 build $VERSION
  [ $status -eq 0 ]
  echo "$output" | grep -q "xk6 has now produced a new k6 binary"
  ./k6 version | grep -q "$VERSION"
}

# bats test_tags=xk6:build
@test '--k6-version version' {
  check_xk6_version
  VERSION=$K6_OTHER_VERSION
  unset K6_VERSION

  run $XK6 build --k6-version $VERSION
  [ $status -eq 0 ]
  echo "$output" | grep -q "xk6 has now produced a new k6 binary"
  ./k6 version | grep -q "$VERSION"
}

# bats test_tags=xk6:build
@test 'K6_VERSION=version' {
  export K6_VERSION=$K6_OTHER_VERSION

  run $XK6 build
  [ $status -eq 0 ]
  echo "$output" | grep -q "xk6 has now produced a new k6 binary"
  ./k6 version | grep -q "$K6_VERSION"
}

# bats test_tags=xk6:build
@test '--k6-repo module' {
  check_xk6_version
  unset XK6_K6_REPO

  run $XK6 build --k6-repo github.com/grafana/k6
  [ $status -eq 0 ]
  echo "$output" | grep -q "xk6 has now produced a new k6 binary"
  echo "$output" | grep -q "adding dependency go.k6.io/k6 => github.com/grafana/k6@latest"
  ./k6 version
}

# bats test_tags=xk6:build
@test 'XK6_K6_REPO=module' {
  if [ -z "$XK6_K6_REPO" ]; then
    export XK6_K6_REPO=github.com/grafana/k6
    export XK6EA_K6_REPO=$XK6_K6_REPO # TODO remove after merging https://github.com/grafana/xk6/pull/167
  fi

  run $XK6 build
  [ $status -eq 0 ]
  echo "$output" | grep -q "xk6 has now produced a new k6 binary"
  echo "$output" | grep -q "adding dependency go.k6.io/k6 => github.com/grafana/k6@latest"
  ./k6 version
}

# bats test_tags=xk6:build
@test '--output dir' {
  mkdir subdir
  run $XK6 build --output subdir/k6
  [ $status -eq 0 ]
  ./subdir/k6 version
}

# bats test_tags=xk6:build
@test '-o dir' {
  check_xk6_version
  mkdir subdir
  run $XK6 build --output subdir/k6
  [ $status -eq 0 ]
  ./subdir/k6 version
}

# bats test_tags=xk6:build
@test '--with module' {
  run $XK6 build --with $IT_MOD
  [ $status -eq 0 ]
  echo "$output" | grep -q "xk6 has now produced a new k6 binary"
  ./k6 version | grep -q "k6/x/it"
  ./k6 run $IT_DIR/script.js | grep -q '✓ it'
  ./k6 run -o it $IT_DIR/script.js 2>&1 >/dev/null | grep -q '"checks"'
}

# bats test_tags=xk6:build
@test '--with module=.' {
  cd $IT_DIR
  run $XK6 build --output ${BATS_TEST_TMPDIR}/k6 --with ${IT_MOD}=.
  [ $status -eq 0 ]
  ${BATS_TEST_TMPDIR}/k6 version | grep -q "k6/x/it"
  ${BATS_TEST_TMPDIR}/k6 run script.js | grep -q '✓ it'
}

# bats test_tags=xk6:build
@test '--with module=local' {
  run $XK6 build --with $IT_MOD=$IT_DIR --with $EXT_MOD/base32=$EXT_DIR/base64-as-base32
  [ $status -eq 0 ]
  echo "$output" | grep -q "xk6 has now produced a new k6 binary"
  ./k6 version | grep -q "k6/x/it/base32"
  ./k6 run $EXT_DIR/base64-as-base32/script.js | grep -q '✓ base64'
}

# bats test_tags=xk6:build,xk6:smoke
@test '--with module=remote' {
  run $XK6 build --with $IT_MOD=$IT_DIR --with $EXT_MOD/base32=$EXT_MOD/base64-as-base32@$EXT_VER
  [ $status -eq 0 ]
  echo "$output" | grep -q "xk6 has now produced a new k6 binary"
  ./k6 version | grep -q "k6/x/it/base32"
  ./k6 run $EXT_DIR/base64-as-base32/script.js | grep -q '✓ base64'
}

# bats test_tags=xk6:build
@test '--replace module=local' {
  run $XK6 build --with $IT_MOD@$IT_VER --with $EXT_MOD/base32 --replace $EXT_MOD/base32=$EXT_DIR/base64-as-base32
  [ $status -eq 0 ]
  echo "$output" | grep -q "xk6 has now produced a new k6 binary"
  ./k6 version | grep -q "k6/x/it/base32"
  ./k6 run $EXT_DIR/base64-as-base32/script.js | grep -q '✓ base64'
}

# bats test_tags=xk6:build
@test '--replace module=remote' {
  run $XK6 build --with $IT_MOD@$IT_VER --with $EXT_MOD/base32 --replace $EXT_MOD/base32=$EXT_MOD/base64-as-base32@$EXT_VER
  [ $status -eq 0 ]
  echo "$output" | grep -q "xk6 has now produced a new k6 binary"
  ./k6 version | grep -q "k6/x/it/base32"
  ./k6 run $EXT_DIR/base64-as-base32/script.js | grep -q '✓ base64'
}

# bats test_tags=xk6:build
@test '--with module1=local1 --with module2=local2 --with module3=local3' {
  run $XK6 build --with $IT_MOD=$IT_DIR --with $EXT_MOD/base32=$EXT_DIR/base32 --with $EXT_MOD/base64=$EXT_DIR/base64 --with $EXT_MOD/ascii85=$EXT_DIR/ascii85
  [ $status -eq 0 ]
  echo "$output" | grep -q "xk6 has now produced a new k6 binary"
  run ./k6 version
  echo "$output" | grep -q "k6/x/it/base32"
  echo "$output" | grep -q "k6/x/it/base64"
  echo "$output" | grep -q "k6/x/it/ascii85"
  ./k6 run $EXT_DIR/base32/script.js | grep -q '✓ base32'
  ./k6 run $EXT_DIR/base64/script.js | grep -q '✓ base64'
  ./k6 run $EXT_DIR/ascii85/script.js | grep -q '✓ ascii85'
}
