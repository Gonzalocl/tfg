#!/bin/bash

if [[ $# -ne 2 ]]; then
  echo Error: need 2 params 1>&2
  exit 1
fi

echo "Cuts timestamps csv file: $1"
echo "Video folder: $2"

out_dir="out"

mkdir -p "$out_dir"

