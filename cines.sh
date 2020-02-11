#!/bin/bash


dataset_dir=datasets/acdc
output_dir=output/cines
rm -rf $output_dir
mkdir $output_dir


for patient in $(ls $dataset_dir/* | grep '.cfg' | cut -d '.' -f 1); do
  mkdir $output_dir/$patient
  cp $dataset_dir/*/$patient.shape $output_dir/$patient
  cp $dataset_dir/*/$patient.cfg $output_dir/$patient
  frames=$(grep Frames $output_dir/$patient/$patient.shape | cut -d ':' -f 2 | tr -d ' ')
  slices=$(grep Slices $output_dir/$patient/$patient.shape | cut -d ':' -f 2 | tr -d ' ')
  class=$(grep Group $output_dir/$patient/$patient.cfg | cut -d ':' -f 2 | tr -d ' ')
  echo $patient $frames $slices $class
  for f in $(printf "%02d " $(seq 0 $(($frames-1)))); do
    ffmpeg -r 2 -i $dataset_dir/$class/${patient}_nohash_frame${f}_slice%02d.jpg $output_dir/$patient/${patient}_frame$f.mp4
  done
  for s in $(printf "%02d " $(seq 0 $(($slices-1)))); do
    ffmpeg -r 9 -i $dataset_dir/$class/${patient}_nohash_frame%02d_slice$s.jpg $output_dir/$patient/${patient}_slice$s.mp4
  done
done






