# shellcheck disable=2030,2031

set -e -u -o pipefail
shopt -s inherit_errexit

declare -a docker_run_options

run() (
  prog=${BASH_SOURCE[1]}
  lib=$YAML_SPEC_ROOT/tool/lib
  code=$(echo "$lib/${prog##*/}"*)
  lang=$(head -n1 "${code:?}")
  lang=${lang#*\ }
  name=$(basename "$prog")

  if check; then
    run-local "$@"
  else
    run-docker "$@"
  fi
)

run-local() (
  "$lang" "$code" "$@"
)

run-docker() (
  args=()
  for arg; do
    if [[ $arg == "$YAML_SPEC_ROOT"/* ]]; then
      arg=/host/${arg#$YAML_SPEC_ROOT/}
    fi
    args+=("$arg")
  done

  image=$(
    grep DOCKER_IMAGE_NAME \
      "$YAML_SPEC_ROOT/tool/docker/$name/docker.mk" |
      cut -d' ' -f3
  )
  version=$(
    grep DOCKER_IMAGE_TAG \
      "$YAML_SPEC_ROOT/tool/docker/$name/docker.mk" |
      cut -d' ' -f3
  )
  image=yamlio/$image:$version

  [[ -t 0 ]] && flags=('-i') || flags=()

  set -x
  docker run "${flags[@]}" --rm \
    --volume "$YAML_SPEC_ROOT":/host \
    --workdir "/host/$YAML_SPEC_DIR" \
    "${docker_run_options[@]}" \
    "$image" \
    "$name" "${args[@]}"
)

die() ( echo "$*" >&2; exit 1 )
