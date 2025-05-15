#!/usr/bin/env bats

setup_file() {
  cd $BATS_FILE_TMPDIR
  git clone --depth 1 https://github.com/grafana/xk6-example.git xk6-it
  cd xk6-it
  git checkout $(git tag -l --sort=version:refname | head -1)
  rm -rf .git
  git init
  git config --local user.name user
  git config --local user.email user@example.com
  git remote add origin https://github.com/grafana/xk6-it.git
  git add .
  git commit -m "Initial commit"

  export DESCRIPTION=$(curl -sL https://api.github.com/repos/grafana/xk6-it | jq -r '.description')
}

setup() {
  load helpers
  _common_setup
  cd $BATS_TEST_TMPDIR
  check_xk6_new
  cp -rp $BATS_FILE_TMPDIR/xk6-it .
  cd xk6-it
}

check_xk6_new() {
  if ! $XK6 --help | grep -q "  new  "; then
    skip "unsupported xk6 version"
  fi
}

@test '⚙ $(basename $BATS_TEST_FILENAME) K6_VERSION=$K6_VERSION; XK6_K6_REPO=$XK6_K6_REPO' {}

# bats test_tags=xk6:adjust,xk6:smoke
@test 'no args' {
  run $XK6 adjust
  [ $status -eq 0 ]
  grep -q "package it" *.go
  grep -q "$DESCRIPTION" README.md
  run $XK6 build --with github.com/grafana/xk6-it=.
  [ $status -eq 0 ]
  echo "$output" | grep -q "xk6 has now produced a new k6 binary"
  ./k6 version | grep -q "github.com/grafana/xk6-it"
}

# bats test_tags=xk6:adjust
@test 'with args' {
  cd ..
  run $XK6 adjust xk6-it
  [ $status -eq 0 ]
  cd xk6-it
  grep -q "package it" *.go
  grep -q "$DESCRIPTION" README.md
  run $XK6 build --with github.com/grafana/xk6-it=.
  [ $status -eq 0 ]
  echo "$output" | grep -q "xk6 has now produced a new k6 binary"
  ./k6 version | grep -q "github.com/grafana/xk6-it"
}

# bats test_tags=xk6:adjust
@test '--description no-such-string' {
  run $XK6 adjust --description no-such-string
  [ $status -eq 0 ]
  grep -q "package it" *.go
  grep -q no-such-string README.md
  run $XK6 build --with github.com/grafana/xk6-it=.
  [ $status -eq 0 ]
  echo "$output" | grep -q "xk6 has now produced a new k6 binary"
  ./k6 version | grep -q "github.com/grafana/xk6-it.*js"
}

# bats test_tags=xk6:adjust
@test '--package wonderland' {
  run $XK6 adjust --package wonderland
  [ $status -eq 0 ]
  grep -q "package wonderland" *.go
  grep -q "$DESCRIPTION" README.md
  run $XK6 build --with github.com/grafana/xk6-it=.
  [ $status -eq 0 ]
  echo "$output" | grep -q "xk6 has now produced a new k6 binary"
  ./k6 version | grep -q "k6/x/wonderland"
}
