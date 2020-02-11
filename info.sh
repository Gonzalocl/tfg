#!/bin/bash



output_dir=output/cines

patient=patient001
headers=patient,
headers=$headers$(cat $output_dir/$patient/$patient.cfg | cut -d ':' -f 1 | tr '\n' ',')
headers=$headers$(cat $output_dir/$patient/$patient.shape | cut -d ':' -f 1 | tr '\n' ',' | rev | cut -c 1 --complement | rev)
echo $headers


for patient in $(ls $output_dir); do
  echo -n $patient,
  cat $output_dir/$patient/$patient.cfg | cut -d ':' -f 2 | tr -d ' ' | tr '\n' ','
  cat $output_dir/$patient/$patient.shape | cut -d ':' -f 2 | tr -d ' ' | tr '\n' ',' | rev | cut -c 1 --complement | rev
#  for h in $(echo $headers | tr ',' ' '); do
#    echo $h
#  done
#  frames=$(grep Frames $output_dir/$patient/$patient.shape | cut -d ':' -f 2 | tr -d ' ')
#  slices=$(grep Slices $output_dir/$patient/$patient.shape | cut -d ':' -f 2 | tr -d ' ')
#  class=$(grep Group $output_dir/$patient/$patient.cfg | cut -d ':' -f 2 | tr -d ' ')
#  echo $patient $frames $slices $class
done






