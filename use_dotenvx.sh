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

  env | sort >"$old_env"
  dotenvx run "${dotenvx_env[@]}" -- env | sort >"$new_env"

  added_vars=$(comm -13 "$old_env" "$new_env" | grep '=')

  if [ -n "$added_vars" ]; then
    printf "use_dotenvx: loaded variables from %s: " "$used_file" >&2
  fi

  while IFS='=' read -r key _value; do
    if [[ "$key" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ && "$key" != "_" && "$key" != "PKG_EXECPATH" ]]; then
      printf "+%s " "$key" >&2
    fi
  done <<<"$added_vars"

  echo "" >&2
  rm -f "$old_env" "$new_env"
}
