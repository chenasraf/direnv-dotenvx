#!/usr/bin/env bash

use_dotenvx() {
  local env_file=".env.${1:-default}"
  if [ -f "$env_file" ]; then
    eval "$(dotenvx --env "$env_file" export)"
  elif [ -f ".env" ]; then
    eval "$(dotenvx export)"
  fi
}
