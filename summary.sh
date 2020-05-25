#!/bin/bash


echo test,accuracy


output_dir="output/00_flowers_test"
results_dir="$output_dir/r"
if [[ -d $results_dir ]]; then
  test="flowers_test"
  accuracy=$(grep "Final test accuracy" "$results_dir/out" | cut -d '%' -f 1 | cut -d '=' -f 2 | tr -d [:blank:])
  echo "$test,$accuracy"
fi

