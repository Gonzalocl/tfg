#!/bin/bash

if [[ $# -ne 2 ]]; then
  echo Error: need 2 params 1>&2
  exit 1
fi

echo "Cuts timestamps csv file: $1"
echo "Video folder: $2"

cut_timestamps="$1"
video_src="$2"
out_dir="out"

function get_out_path {
  filename="$(echo $1 | tr -d -c '[:alnum:]')"
  t0="$(echo $2 | tr -d -c '[:alnum:]')"
  t1="$(echo $3 | tr -d -c '[:alnum:]')"
  echo "$out_dir/cut_$filename$t0$t1.mp4"
}

function get_timestamp {
  echo "01:02:03.0"
}

function ffcut {
  filename="$video_src/$1"
  t0="$(get_timestamp $2)"
  t1="$(get_timestamp $3)"
  echo ffmpeg -ss "$t0" -i "$filename" -to "$t1" -filter:v "crop=1080:1080:0:420" -preset ultrafast "$(get_out_path $filename $t0 $t1)"
}

mkdir -p "$out_dir"

ffcut VID_20200626_144413.mp4 0 16

