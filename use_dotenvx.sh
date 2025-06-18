#!/usr/bin/env bash

use_dotenvx() {
  local env_file=".env.${1:-default}"
  local dotenvx_env=()
  local used_file=""

  if [ -f "$env_file" ]; then
    dotenvx_env=(--env "$env_file")
    used_file="$env_file"
  elif [ -f ".env" ]; then
    used_file=".env"
  else
    echo "use_dotenvx: no .env file found" >&2
    return 0
  fi

  local old_env new_env added_vars
  old_env=$(mktemp)
  new_env=$(mktemp)

  env | LC_ALL=C sort >"$old_env"
  dotenvx run "${dotenvx_env[@]}" -- env | LC_ALL=C sort >"$new_env"

  added_vars=$(comm -13 "$old_env" "$new_env" | grep '=')

  if [ -n "$added_vars" ]; then
    printf "use_dotenvx: loaded variables from %s\n" "$used_file" >&2
  fi

  local EXCLUDE_KEYS=("_" "PKG_EXECPATH" "DOTENV_PUBLIC_KEY")
  _is_excluded() {
    local key="$1"
    for excluded in "${EXCLUDE_KEYS[@]}"; do
      [[ "$key" == "$excluded" ]] && return 0
    done
    return 1
  }

  while IFS='=' read -r key value; do
    if [[ "$key" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]] && ! _is_excluded "$key"; then
      export "$key=$(printf '%q' "$value")"
    fi
  done <<<"$added_vars"

  rm -f "$old_env" "$new_env"
}
