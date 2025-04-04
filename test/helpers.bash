_common_setup() {
  BASEDIR=$(dirname $BATS_TEST_DIRNAME)

  EXT_DIR="${BASEDIR}/ext"
  EXT_MOD=github.com/grafana/xk6-it/ext
  EXT_VER=latest

  IT_DIR=$BASEDIR
  IT_MOD=github.com/grafana/xk6-it
  IT_VER=latest

  XK6=${XK6:-$(which xk6)}
  K6_VERSION=$(_k6_version)

  if $XK6 build --with 2>&1 | grep -q "build error parsing options expected value after --with flag"; then
    XK6_LEGACY=true
  fi
}

_k6_version() {
  if [ -z "$K6_VERSION" ] || [ "$K6_VERSION" = "latest" ]; then
    _latest_k6_version
  else
    echo -n "$K6_VERSION"
  fi
}

_latest_k6_version() {
  url=$(wget -q -O - --spider -S "https://github.com/grafana/k6/releases/latest" 2>&1 | grep Location)
  echo -n "v${url##*v}"
}

check_xk6_version() {
  if [[ $XK6_LEGACY ]]; then
    skip "unsupported xk6 version"
  fi
}
