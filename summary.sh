#!/bin/bash


function inference_accuracy {
  test="$1"
  results_file="$2"
  accuracy=$(tail -n 1 "$results_file" | cut -d '%' -f 1 | cut -d ':' -f 2 | tr -d [:blank:])
  echo "$test,$accuracy"
}

echo test,accuracy


output_dir="output/00_flowers_test"
results_dir="$output_dir/r"
if [[ -d $results_dir ]]; then
  test="flowers_test"
  accuracy=$(grep "Final test accuracy" "$results_dir/out" | cut -d '%' -f 1 | cut -d '=' -f 2 | tr -d [:blank:])
  echo "$test,$accuracy"
fi


results_dir="output/01_acdc_test/r"
if [[ -d $results_dir ]]; then
  inference_accuracy "acdc_test" "$results_dir/output_inference"
  inference_accuracy "acdc_test_per_patient_prediction" "$results_dir/output_per_patient_prediction"
fi
