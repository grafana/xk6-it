_common_setup() {
  BASEDIR=$(dirname $BATS_TEST_DIRNAME)

  EXT_DIR="${BASEDIR}/ext"
  EXT_MOD=github.com/grafana/xk6-it/ext
  EXT_VER=latest

  IT_DIR=$BASEDIR
  IT_MOD=github.com/grafana/xk6-it
  IT_VER=latest

  XK6=${XK6:-$(which xk6)}
  if [ ! -x "$XK6" ]; then
    echo "ERROR: Missing xk6, try to set XK6 environment variable." >&2
    exit 2
  fi

  K6_VERSION=$(_k6_version)
  K6_LATEST_VERSION=$(_latest_k6_version)
  K6_OTHER_VERSION=v0.57.0
  K6_ORHER_VERSION_HASH=50afd82c18d5a66f4b2bfd1f8d266218bfdeaede

  EXE_SUFFIX=$(_exe_suffix)

  export K6=${BATS_TEST_TMPDIR}/k6${EXE_SUFFIX}
}

_k6_version() {
  if [ -z "$K6_VERSION" ] || [ "$K6_VERSION" = "latest" ]; then
    _latest_k6_version
  else
    echo -n "$K6_VERSION"
  fi
}

_latest_k6_version() {
  local url=$(curl -s -I https://github.com/grafana/k6/releases/latest | grep -i location)
  local version="${url##*v}"
  version=${version//[[:space:]]/}
  echo -n "v${version}"
}

_exe_suffix() {
  if ! uname >/dev/null 2>/dev/null; then
    echo -n ".exe"
    return
  fi

  case "$(uname)" in
  CYGWIN* | MINGW* | MINGW32* | MSYS*)
    echo -n ".exe"
    ;;
  esac
}

# TODO remove after merging https://github.com/grafana/xk6/pull/167
check_xk6_version() {
  if $XK6 build --with 2>&1 | grep -q "build error parsing options expected value after --with flag"; then
    skip "unsupported xk6 version"
  fi
}
