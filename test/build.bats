#!/usr/bin/env bats

setup() {
  load helpers
  _common_setup
  cd $BASEDIR
  rm -f k6
}

@test '⚙ K6_VERSION=$K6_VERSION; K6_REPO=$K6_REPO' {}

@test 'no arg' {
  run $XK6 build
  [ $status -eq 0 ]
  echo "$output" | grep -q "xk6 has now produced a new k6 binary"
  ./k6 version
}

@test 'version arg' {
  VERSION=$K6_VERSION
  unset K6_VERSION

  run $XK6 build $VERSION
  [ $status -eq 0 ]
  echo "$output" | grep -q "xk6 has now produced a new k6 binary"
  ./k6 version | grep -q "$VERSION"
}

@test '--k6-version version' {
  check_xk6_version
  VERSION=$K6_VERSION
  unset K6_VERSION

  run $XK6 build --k6-version $VERSION
  [ $status -eq 0 ]
  echo "$output" | grep -q "xk6 has now produced a new k6 binary"
  ./k6 version | grep -q "$VERSION"
}

@test '--with module' {
  run $XK6 build --with $IT_MOD
  [ $status -eq 0 ]
  echo "$output" | grep -q "xk6 has now produced a new k6 binary"
  ./k6 version | grep -q "k6/x/it"
  ./k6 run $IT_DIR/script.js | grep -q '✓ it'
  ./k6 run -o it $IT_DIR/script.js 2>&1 >/dev/null | grep -q '"checks"'
}

@test '--with module=.' {
  cd $IT_DIR
  run $XK6 build --with ${IT_MOD}=.
  [ $status -eq 0 ]
  echo "$output" | grep -q "xk6 has now produced a new k6 binary"
  ./k6 version | grep -q "k6/x/it"
  ./k6 run script.js | grep -q '✓ it'
}

@test '--with module=local' {
  run $XK6 build --with $IT_MOD=$IT_DIR --with $EXT_MOD/base32=$EXT_DIR/base64-as-base32
  [ $status -eq 0 ]
  echo "$output" | grep -q "xk6 has now produced a new k6 binary"
  ./k6 version | grep -q "k6/x/it/base32"
  ./k6 run $EXT_DIR/base64-as-base32/script.js | grep -q '✓ base64'
}

@test '--with module=remote' {
  run $XK6 build --with $IT_MOD=$IT_DIR --with $EXT_MOD/base32=$EXT_MOD/base64-as-base32@$EXT_VER
  [ $status -eq 0 ]
  echo "$output" | grep -q "xk6 has now produced a new k6 binary"
  ./k6 version | grep -q "k6/x/it/base32"
  ./k6 run $EXT_DIR/base64-as-base32/script.js | grep -q '✓ base64'
}

@test '--replace module=local' {
  run $XK6 build --with $IT_MOD@$IT_VER --with $EXT_MOD/base32 --replace $EXT_MOD/base32=$EXT_DIR/base64-as-base32
  [ $status -eq 0 ]
  echo "$output" | grep -q "xk6 has now produced a new k6 binary"
  ./k6 version | grep -q "k6/x/it/base32"
  ./k6 run $EXT_DIR/base64-as-base32/script.js | grep -q '✓ base64'
}

@test '--replace module=remote' {
  run $XK6 build --with $IT_MOD@$IT_VER --with $EXT_MOD/base32 --replace $EXT_MOD/base32=$EXT_MOD/base64-as-base32@$EXT_VER
  [ $status -eq 0 ]
  echo "$output" | grep -q "xk6 has now produced a new k6 binary"
  ./k6 version | grep -q "k6/x/it/base32"
  ./k6 run $EXT_DIR/base64-as-base32/script.js | grep -q '✓ base64'
}

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

# bats test_tags=bats:focus
