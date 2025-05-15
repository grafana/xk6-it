#!/usr/bin/env bats

setup() {
  load helpers
  _common_setup
  cd $BATS_TEST_TMPDIR
  check_xk6_new
}

check_xk6_new() {
  if ! $XK6 --help | grep -q "  new  "; then
    skip "unsupported xk6 version"
  fi
}

@test '⚙ $(basename $BATS_TEST_FILENAME) K6_VERSION=$K6_VERSION; XK6_K6_REPO=$XK6_K6_REPO' {}

# bats test_tags=xk6:new,xk6:smoke
@test 'no flags' {
  run $XK6 new example.com/user/xk6-demo
  [ $status -eq 0 ]
  cd xk6-demo
  grep -q "package demo" *.go
  run $XK6 build --with example.com/user/xk6-demo=.
  [ $status -eq 0 ]
  echo "$output" | grep -q "xk6 has now produced a new k6 binary"
  ./k6 version | grep -q "example.com/user/xk6-demo"
}

# bats test_tags=xk6:new
@test '--type javascript' {
  run $XK6 new --type javascript --description no-such-string example.com/user/xk6-demo
  [ $status -eq 0 ]
  cd xk6-demo
  grep -q "package demo" *.go
  grep -q no-such-string README.md
  run $XK6 build --with example.com/user/xk6-demo=.
  [ $status -eq 0 ]
  echo "$output" | grep -q "xk6 has now produced a new k6 binary"
  ./k6 version | grep -q "example.com/user/xk6-demo.*js"
}

# bats test_tags=xk6:new
@test '--type output' {
  run $XK6 new --type output --description no-such-string example.com/user/xk6-demo
  [ $status -eq 0 ]
  cd xk6-demo
  grep -q "package demo" *.go
  grep -q no-such-string README.md
  run $XK6 build --with example.com/user/xk6-demo=.
  [ $status -eq 0 ]
  echo "$output" | grep -q "xk6 has now produced a new k6 binary"
  ./k6 version | grep -q "example.com/user/xk6-demo.*output"
}

# bats test_tags=xk6:new
@test '--package wonderland' {
  run $XK6 new --package wonderland example.com/user/xk6-demo
  [ $status -eq 0 ]
  cd xk6-demo
  grep -q "package wonderland" *.go
  run $XK6 build --with example.com/user/xk6-demo=.
  [ $status -eq 0 ]
  echo "$output" | grep -q "xk6 has now produced a new k6 binary"
  ./k6 version | grep -q "k6/x/wonderland"
}

# bats test_tags=xk6:new
@test '--parend-dir parent' {
  mkdir parent
  run $XK6 new --parent-dir parent example.com/user/xk6-demo
  [ $status -eq 0 ]
  test -d parent
  cd parent/xk6-demo
  grep -q "package demo" *.go
  run $XK6 build --with example.com/user/xk6-demo=.
  [ $status -eq 0 ]
  echo "$output" | grep -q "xk6 has now produced a new k6 binary"
}
