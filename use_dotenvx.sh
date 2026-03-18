#!/usr/bin/env bash

_dotenvx_log() {
  local msg="$1"
  if [ -z "$_dotenvx_log_filter" ]; then
    local config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
    local config_file="$config_home/direnv/direnv.toml"
    if [ -f "$config_file" ]; then
      _dotenvx_log_filter=$(sed -n 's/^[[:space:]]*log_filter[[:space:]]*=[[:space:]]*"\(.*\)"/\1/p' "$config_file")
    fi
    _dotenvx_log_filter="${_dotenvx_log_filter:-.*}"
  fi
  if [[ "$msg" =~ $_dotenvx_log_filter ]]; then
    printf "%s\n" "$msg" >&2
  fi
}

use_dotenvx() {
  local env_file=".env.${1:-default}"
  local dotenvx_env=()
  local used_file=""

  if [ -f "$env_file" ]; then
    dotenvx_env=(-f "$env_file")
    used_file="$env_file"
  elif [ -f ".env" ]; then
    used_file=".env"
  else
    _dotenvx_log "use_dotenvx: no .env file found"
    return 0
  fi

  local old_env new_env added_vars
  old_env=$(mktemp)
  new_env=$(mktemp)

  env | LC_ALL=C sort >"$old_env"
  dotenvx run "${dotenvx_env[@]}" -- env | LC_ALL=C sort >"$new_env"

  added_vars=$(comm -13 "$old_env" "$new_env" | grep '=')

  if [ -n "$added_vars" ]; then
    _dotenvx_log "use_dotenvx: loaded variables from $used_file"
  fi

  local EXCLUDE_KEYS=("_" "PKG_EXECPATH")
  _is_excluded() {
    local key="$1"
    for excluded in "${EXCLUDE_KEYS[@]}"; do
      [[ "$key" == "$excluded" ]] && return 0
    done
    if [[ "$key" =~ DOTENV_PUBLIC_KEY.* ]]; then
      return 0
    fi
    return 1
  }

  while IFS='=' read -r key value; do
    if [[ "$key" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]] && ! _is_excluded "$key"; then
      export "$key=$(printf '%q' "$value")"
    fi
  done <<<"$added_vars"

  rm -f "$old_env" "$new_env"
}
