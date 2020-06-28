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
batch_sh="batch.sh"

function get_out_path {
  filename="$(echo $1 | tr -d -c '[:alnum:]')"
  t0="$(echo $2 | tr -d -c '[:alnum:]')"
  t1="$(echo $3 | tr -d -c '[:alnum:]')"
  echo "$out_dir/cut_$filename$t0$t1.mp4"
}

function get_timestamp {
  ts_format="$(echo $1 | tr -d -c ':')"
  if [[ $ts_format ]]; then
    echo "$1"
  else
    echo "00:00:$1"
  fi
}

function ffcut {
  filename="$1"
  t0="$2"
  t1="$3"
  echo ffmpeg -i "$video_src/$filename" -ss "$t0" -to "$t1" -filter:v "crop=1080:1080:0:420" -preset ultrafast "$(get_out_path $filename $t0 $t1)" >> "$batch_sh"
}

mkdir -p "$out_dir"
echo "#!/bin/bash" > "$batch_sh"

while read l; do
  filename="$(echo $l | cut -d ',' -f 1)"
  t0="$(get_timestamp $(echo $l | cut -d ',' -f 2))"
  t1="$(get_timestamp $(echo $l | cut -d ',' -f 3 | tr -d '\r'))"
  
  file_path="$(get_out_path $filename $t0 $t1)"
  
  if [[ -f $file_path ]]; then
    echo "File already processed: $filename"
  else
    echo "Processing: $filename"
    ffcut "$filename" "$t0" "$t1"
  fi
  
done < "$cut_timestamps"


