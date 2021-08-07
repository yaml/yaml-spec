# shellcheck disable=2030,2031

set -e -u -o pipefail
shopt -s inherit_errexit

declare -a docker_run_options

run-local-or-docker() (
  name=$(basename "${BASH_SOURCE[1]}")

  if check; then
    run-local "$@"
  else
    run-docker "$@"
  fi
)

run-local() (
  "$YAML_SPEC_ROOT/tool/bin/$name" "$@"
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
