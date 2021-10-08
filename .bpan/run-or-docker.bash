#!/bash

# shellcheck disable=2030,2031,2154

set -e -u -o pipefail

# shellcheck disable=2206
declare -a docker_run_options=(${RUN_OR_DOCKER_OPTIONS-})
RUN_OR_DOCKER_PULL=${RUN_OR_DOCKER_PULL:-false}
RUN_OR_DOCKER_PUSH=${RUN_OR_DOCKER_PUSH:-false}

run() (
  bin=$(dirname "${BASH_SOURCE[1]}")
  self=$(basename "${BASH_SOURCE[1]}")
  root=${ROOT:-$PWD}
  prog=$(cd "$bin" && echo "$self".*)
  image=yamlio/$self:$version

  if [[ $prog == *'.*' ]]; then
    prog=$self
    lang=bash
  else
    case $prog in
      *.sh) lang=bash ;;
      *.bash) lang=bash ;;
      *.pl) lang=perl ;;
      *.py) lang=python3 ;;
      *) die "Don't recognize language of '$prog'" ;;
    esac
  fi

  if $RUN_OR_DOCKER_PUSH; then
    build-docker-image
    exit
  fi

  if [[ -e /.dockerenv || ${RUN_OR_DOCKER-} == local ]]; then
    if [[ $self == "$prog" ]]; then
      main "$@"
    else
      run-local "$@"
    fi
    return
  fi

  if [[ ${RUN_OR_DOCKER-} == force* || ${GITHUB_ACTIONS-} ]]; then
    run-docker "$@"
    return
  fi

  out=$(check 2>&1) && rc=0 || rc=$?

  [[ $rc == 0 || $out == CHECK:* ]] || die "Error: $out"

  if [[ $rc -eq 0 ]]; then
    run-local "$@"
  else
    echo "Can't run '$self' locally: ${out#CHECK:\ }"
    echo "Running with docker..."
    run-docker "$@"
  fi
)

run-local() (
  export RUN_OR_DOCKER=local
  "$lang" "$bin/$prog" "$@"
)

run-docker() (
  if [[ ${RUN_OR_DOCKER-} == force-build ]]; then
    build-docker-image
  else
    docker inspect --type=image "$image" &>/dev/null &&
      ok=true || ok=false
    if ! $ok; then
      if $RUN_OR_DOCKER_PULL; then
        (
          set -x
          docker pull "$image"
        )
      else
        build-docker-image
      fi
    fi
  fi

  args=()
  docker_run_options+=(
    --env ROOT=/home/host
  )
  for arg; do
    if [[ $arg == "$root"/* ]]; then
      arg=/home/host/${arg#$root/}
    fi
    args+=("$arg")
  done

  [[ -t 0 ]] && flags=('-it') || flags=()

  workdir=/home/host
  [[ ${RUN_OR_DOCKER_WORKDIR-} ]] &&
    workdir=$workdir/$RUN_OR_DOCKER_WORKDIR

  uid=$(id -u)
  gid=$(id -g)

  set -x
  docker run "${flags[@]}" --rm \
    --volume "$root":/home/host \
    --workdir "$workdir" \
    --user "$uid:$gid" \
    --entrypoint '' \
    "${docker_run_options[@]}" \
    "$image" \
    "$self" "${args[@]}"
)

force() {
  die 'CHECK: docker is forced here'
}

need() {
  [[ $(command -v "$1") ]] || return 1

  [[ ${2-} ]] || return 0

  if [[ ${2-} =~ ^[0-9]+(\.|$) ]]; then
    check=need-version
  else
    check=need-modules
  fi

  "$check" "$@"
}

need-version() {
  cmd=$1 ver=$2

  if [[ $("$cmd" --version) =~ ([0-9]+)\.([0-9]+)(\.[0-9]+)? ]]; then
    set -- "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}" "${BASH_REMATCH[3]#.}"
  else
    die "Could not get version from '$cmd --version'"
  fi

  fail() { die "CHECK: requires '$cmd' version '$ver' or higher"; }

  vers=$ver
  while [[ $vers && $* ]]; do
    v=${vers%%.*}
    if [[ $1 -gt $v ]]; then
      return
    elif [[ $1 -lt $v ]]; then
      fail
    fi
    if [[ $vers != *.* ]]; then
      return
    fi
    vers=${vers#*.}
    shift
  done
  fail
}

need-modules() {
  cmd=$1; shift

  fail() { die "CHECK: '$cmd' requires module '$module'"; }

  for module; do
    case $cmd in
      perl)
        perl -M"$module" -e1 \
          &>/dev/null || fail ;;
      node)
        node -e "require('$module');" \
          &>/dev/null || fail ;;
      *) die "Can't check module '$module' for '$cmd'" ;;
    esac
  done
}

build-docker-image() (
  build=$(mktemp -d --tmpdir run-or-docker-XXXXXX)

  fail() ( die "docker-build failed: $*" )

  cmd() (
    _args=${1//\ \+\ /\ &&\ }
    echo "$_args"
    echo
  )

  run() (
    cmd "RUN $*"
  )

  from() {
    _from=$1
    case $_from in
      alpine)
        cmd 'FROM alpine'
        cmd 'WORKDIR /home'
        cmd 'RUN apk update && apk add bash build-base coreutils'
        ;;
      ubuntu)
        cmd 'FROM ubuntu:20.04'
        cmd 'WORKDIR /home'
        cmd 'RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential'
        ;;
      *) fail "from $*"
    esac
  }

  pkg() (
    case $_from in
      alpine)
        cmd "RUN apk add $*"
        ;;
      ubuntu)
        cmd "RUN DEBIAN_FRONTEND=noninteractive apt-get install -y $*"
        ;;
      *) fail "pkg $*"
    esac
  )

  cpan() (
    case $_from in
      alpine)
        pkg perl perl-dev perl-app-cpanminus wget
        ;;
      ubuntu)
        pkg cpanminus
        ;;
      *) fail "cpan $*"
    esac

    cmd "RUN cpanm -n $*"
  )

  npm() (
    case $_from in
      alpine)
        pkg nodejs npm
        ;;
      *) fail "npm $*"
    esac

    cmd "RUN mkdir node_modules && npm install $*"
  )

  (
    dockerfile

    cmd "ENV PATH=/home/host/bin:\$PATH"
  ) > "$build/Dockerfile"


  (
    set -x
    cd "$build"
    docker build -t "$image" .
  )

  rm -fr "$build"

  if $RUN_OR_DOCKER_PUSH; then
    (
      set -x
      docker push "$image"
    )
  fi
)

die() { echo "$*" >&2; exit 1; }
