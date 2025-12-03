#!/usr/bin/env bats

setup() {
  bats_require_minimum_version 1.5.0
  load helpers
  _common_setup
  cd $BATS_TEST_TMPDIR
  check_xk6_test
}

check_xk6_test() {
  if ! $XK6 --help | grep -q "  test  "; then
    skip "unsupported xk6 version"
  fi
}

@test '⚙ $(basename $BATS_TEST_FILENAME) K6_VERSION=$K6_VERSION; XK6_K6_REPO=$XK6_K6_REPO' {}

diffable() {
  jq '. |= (del(.reportId))| del(.timestamp)|del(.results.tool.version)|del(.results.summary.start)|del(.results.summary.stop)|del(.results.summary.duration)|.results.tests[]|= (del(.duration)|del(.start)|del(.duration))'
}

golden_test() {
  check_xk6_test

  local dir=$EXT_DIR/${1:-..}
  local patterns=("**/script.js" "test.js")
  local golden=testreport.json
  local goldentxt=testreport.txt
  local got=$BATS_TEST_TMPDIR/got.json
  local want=$BATS_TEST_TMPDIR/want.json
  local gottxt=$BATS_TEST_TMPDIR/got.txt

  local with=(
    "--with" "github.com/grafana/xk6-it=."
    "--with" "github.com/grafana/xk6-it/ext/ascii85=./ext/ascii85"
    "--with" "github.com/grafana/xk6-it/ext/base32=./ext/base32"
    "--with" "github.com/grafana/xk6-it/ext/base64=./ext/base64"
    "--with" "github.com/grafana/xk6-it/ext/crc32=./ext/crc32"
    "--with" "github.com/grafana/xk6-it/ext/sha1=./ext/sha1"
    "--with" "github.com/grafana/xk6-it/ext/sha256=./ext/sha256"
    "--with" "github.com/grafana/xk6-it/ext/sha512=./ext/sha512"
  )

  cd $dir

  # Pre-build the k6 binary if K6 is set
  if [ -n "$K6" ]; then
    $XK6 build -v ${with[@]} --output $K6
    with=()
  fi

  if [ ! -f $golden ]; then
    $XK6 test ${with[@]} --json -o $golden ${patterns[@]} || true
    $XK6 test ${with[@]} -o $goldentxt ${patterns[@]} || true
  fi

  run --separate-stderr $XK6 test ${with[@]} --json ${patterns[@]}
  echo "$output" | diffable >$got
  cat $golden | diffable >$want
  diff $want $got
  
  run --separate-stderr $XK6 test ${with[@]} -o $gottxt ${patterns[@]}
  diff $goldentxt $gottxt
}

# bats test_tags=xk6:test,xk6:smoke
@test 'pre-built-binary' {
  golden_test
}

# bats test_tags=xk6:test,xk6:smoke
@test 'on-the-fly-build' {
  unset K6
  golden_test
}


