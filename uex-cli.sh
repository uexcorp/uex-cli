#!/bin/bash

# Declare global variables
environment=""
secret_key=""

uex_api_url_local="http://localhost/uex/uex-v2/api/cli/"
uex_api_url_ptu="https://ptu.uexcorp.space/api/cli"
uex_api_url_production="https://uexcorp.space/api/cli"

secret_file_key="$HOME/.uexkey"
secret_file_env="$HOME/.uexenv"

function set_key {
  if [ -z "$1" ]; then
    rm -f "$secret_file_key"
    printf "\033[1;33mSecret key cleared\033[0m\n"
  else
    echo "$1" > "$secret_file_key"
    secret_key="$1"
    printf "\033[0;32mSecret key set successfully\033[0m\n"
  fi
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
  export environment
}

# Check if the .uexenv file exists and set the environment variable
if [ -f "$secret_file_env" ]; then
  environment=$(cat "$secret_file_env") || { echo "Error reading environment file."; exit 1; }
else
  # Set default environment if not already set
  echo "production" > "$secret_file_env"
  environment="production"
fi
export environment

if [ "$environment" != "production" ]; then
  printf "\n\033[0;32mWelcome to UEX CLI! ($environment)\033[0m\n"
else
  printf "\n\033[0;32mWelcome to UEX CLI!\033[0m\n"
fi

# Check if the .uexkey file exists and set the secret key
if [ -f "$secret_file_key" ]; then
  secret_key=$(cat "$secret_file_key") || { echo "Error reading secret key file."; exit 1; }
else
  printf "\033[1;30mNo secret key set. Use 'set key <value>' to set the secret key.\033[0m\n"
fi

while true; do

  read -p "UEX> " user_input

  if [ -z "$user_input" ]; then
    continue
  fi

  IFS=' ' read -r -a input_array <<< "$user_input"

  case "${input_array[0]}" in
    "exit")
      echo "See ya!"
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
          echo "Unknown command. Please use 'set key <value>' or 'set env <value>'."
          ;;
      esac
      ;;
    *)
      case "$environment" in
        "local") uex_api_url="$uex_api_url_local" ;;
        "ptu") uex_api_url="$uex_api_url_ptu" ;;
        "production") uex_api_url="$uex_api_url_production" ;;
        *) echo "Unknown environment. Please set the environment using 'set env' command." ;;
      esac

      response=$(curl -s -w "\n%{http_code}" -X POST -d "input=$user_input" -H "secret_key: $secret_key" "$uex_api_url")
      http_code=$(echo "$response" | tail -n 1)
      if [ "$http_code" != "200" ]; then
        printf "\033[0;31mError ($http_code)\033[0m\n"
      else
        printf "%s" "${response%$http_code}"
      fi
      ;;
  esac
done
