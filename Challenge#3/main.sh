#!/bin/bash

function get_value_from_nested_object() {
  local object="$1"
  local key="$2"
  local value=""

  # Split the key into an array of keys
  key_array=($key)

  # Iterate through the key array and get the value
  for key in "${key_array[@]}"
  do
    if [[ -z "$value" ]]; then
      value="$object"
    else
      value=$(echo "$value" | jq ".$key")
    fi
  done

  # Return the value
  echo "$value"
}
