#!/bin/bash

# UEX 2.0 CLI
# Copyright (C) 2954 United Express Corporation. All rights reserved.

environment=""
secret_key=""

uex_api_url_local="http://localhost/uex/uex-v2/cli/"
uex_api_url_ptu="https://ptu.uexcorp.space/cli/"
uex_api_url_production="https://uexcorp.space/cli/"

secret_file_key="$HOME/.uexkey"
secret_file_env="$HOME/.uexenv"

# Helpers

function set_key {
  if [ -z "$1" ]; then
    rm -f "$secret_file_key"
    printf "\033[1;33mSecret key cleared\033[0m\n"
  else
    printf "$1" > "$secret_file_key"
    secret_key="$1"
    printf "\033[0;32mSecret key installed\033[0m\n"
  fi
}

function load_environment {
  case "$environment" in
    "local") uex_api_url="$uex_api_url_local" ;;
    "ptu") uex_api_url="$uex_api_url_ptu" ;;
    "production") uex_api_url="$uex_api_url_production" ;;
    *) printf "\033[0;31mUnknown environment. Please set the environment using 'set env' command.\033[0m\n" ;;
  esac
  export environment
}

function set_environment {
  if [ -z "$1" ]; then
    rm -f "$secret_file_env"
    environment="production"
    printf "\033[1;33mEnvironment cleared\033[0m\n"
  else
    echo "$1" > "$secret_file_env"
    environment="$1"
    printf "\033[0;32mEnvironment set: $1\033[0m\n"
  fi
  load_environment
  export environment
}

function send_request {
  response=$(curl -s -w "\n%{http_code}" -X POST -d "input=$1" -H "secret_key: $secret_key" "$uex_api_url")
  http_code=$(echo "$response" | tail -n 1)
  if [ "$http_code" != "200" ]; then
    printf "\033[0;31mError ($http_code)\033[0m\n"
  else
    printf "%s" "${response%$http_code}"
  fi
}

# Environment instance

if [ -f "$secret_file_env" ]; then
  environment=$(cat "$secret_file_env") || { printf "\033[0;31mError reading environment file.\033[0m\n"; exit 1; }
else
  echo "production" > "$secret_file_env"
  environment="production"
fi
export environment

# Launch

if [ "$environment" != "production" ]; then
  printf "\n\033[0;32mWelcome to UEX CLI ($environment)\033[0m\n"
else
  printf "\n\033[0;32mWelcome to UEX CLI\033[0m\n"
fi

# Secret key

if [ -f "$secret_file_key" ]; then
  secret_key=$(cat "$secret_file_key") || { printf "\033[0;31mError reading secret key file.\033[0m\n"; exit 1; }
else
  printf "\033[1;30mNo secret key set. Use 'set key <value>' to set the secret key.\033[0m\n"
fi

# Environment definition

load_environment

# MOTD

if [ "$secret_key" ]; then
  send_request "__home"
fi

# Action

while true; do

  read -p "UEX> " user_input

  if [ -z "$user_input" ]; then
    continue
  fi

  IFS=' ' read -r -a input_array <<< "$user_input"

  case "${input_array[0]}" in
    "exit")
      printf "\033[1;30mSee you later!\033[0m\n"
      break
      ;;
    "set")
      case "${input_array[1]}" in
        "key")
          set_key "${input_array[2]}"
          ;;
        "env")
          set_environment "${input_array[2]}"
          ;;
        *)
          printf "\033[1;30mUsage:\nset key <value>\t\t# set your secret key\nset env <value>\t\t# set environment (local, ptu or production)\033[0m"
          ;;
      esac
      ;;
    *)
      load_environment

      # Request

      send_request "$user_input"

      ;;
  esac
done
