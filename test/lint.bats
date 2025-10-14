#!/usr/bin/env bats

setup() {
  load helpers
  _common_setup
  cd $BATS_TEST_TMPDIR
}

@test '⚙ $(basename $BATS_TEST_FILENAME) K6_VERSION=$K6_VERSION; XK6_K6_REPO=$XK6_K6_REPO' {}

normalize() {
  jq '.checks[] |= (del(.details))| del(.timestamp)'
}

diffable() {
  jq '{"checks":(.checks|sort_by(.id)|map({(.id):.passed})|add)}'
}

golden_test() {
  check_xk6_version

  local dir=$EXT_DIR/${1:-..}
  local golden=$dir/compliance.json
  local goldentxt=$dir/compliance.txt
  local got=$BATS_TEST_TMPDIR/got.json
  local want=$BATS_TEST_TMPDIR/want.json

  if [ ! -f $golden ]; then
    $XK6 lint --preset strict --json $dir >$golden

    if [ -z "$1" ]; then
      $XK6 lint --preset strict -o $goldentxt $dir || true
    fi
  fi

  run $XK6 lint --preset strict --json $dir
  [ $status -eq 0 ]
  echo "$output" | diffable >$got

  cat $golden | diffable >$want

  diff $want $got
}

# bats test_tags=xk6:lint,xk6:smoke
@test 'it' {
  golden_test
}

# bats test_tags=xk6:lint,xk6:smoke
@test 'base32' {
  golden_test base32
}

# bats test_tags=xk6:lint
@test 'ascii85' {
  golden_test ascii85
}

# bats test_tags=xk6:lint,xk6:smoke
@test 'base64-as-base32' {
  golden_test base64-as-base32
}

# bats test_tags=xk6:lint
@test 'base64' {
  golden_test base64
}

# bats test_tags=xk6:lint
@test 'crc32' {
  golden_test crc32
}

# bats test_tags=xk6:lint,xk6:smoke
@test 'sha1' {
  golden_test sha1
}

# bats test_tags=xk6:lint
@test 'sha256' {
  golden_test sha256
}

# bats test_tags=xk6:lint
@test 'sha512' {
  golden_test sha512
}
