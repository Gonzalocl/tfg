#!/bin/bash


function inference_accuracy {
  test="$1"
  results_file="$2"
  accuracy=$(tail -n 1 "$results_file" | cut -d '%' -f 1 | cut -d ':' -f 2 | tr -d [:blank:])
  echo "$test,$accuracy"
}

function out_accuracy {
  test="$1"
  results_file="$2"
  accuracy=$(grep "Final test accuracy" "$results_file" | cut -d '%' -f 1 | cut -d '=' -f 2 | tr -d [:blank:])
  echo "$test,$accuracy"
}


echo test,accuracy

results_dir="output/00_flowers_test/r"
if [[ -d $results_dir ]]; then
  out_accuracy "00_flowers_test" "$results_dir/out"
fi

results_dir="output/01_acdc_test/r"
if [[ -d $results_dir ]]; then
  inference_accuracy "01_acdc_test" "$results_dir/output_inference"
  inference_accuracy "01_acdc_test_per_patient_prediction" "$results_dir/output_per_patient_prediction"
fi

results_dir="output/02_acdc_one_slice_test/r"
if [[ -d $results_dir ]]; then
  out_accuracy "02_acdc_one_slice_test" "$results_dir/out"
fi

for c in DCM HCM MINF NOR RV; do
  results_dir="output/03_acdc_subset_test/$c/r"
  if [[ -d $results_dir ]]; then
    inference_accuracy "03_acdc_subset_test_$c" "$results_dir/out_inference"
  fi
done

results_dir="output/04_acdc_cascade_test"
if [[ -d $results_dir ]]; then
  inference_accuracy "04_acdc_cascade_test" "$results_dir/testing_output_inference"
  inference_accuracy "04_acdc_cascade_test_per_patient_prediction" "$results_dir/testing_output_per_patient_prediction"
fi

results_dir="output/01_distortion_acdc_test/r"
if [[ -d $results_dir ]]; then
  inference_accuracy "01_distortion_acdc_test" "$results_dir/output_inference"
  inference_accuracy "01_distortion_acdc_test_per_patient_prediction" "$results_dir/output_per_patient_prediction"
fi

results_dir="output/02_distortion_acdc_one_slice_test/r"
if [[ -d $results_dir ]]; then
  out_accuracy "02_distortion_acdc_one_slice_test" "$results_dir/out"
fi

for c in DCM HCM MINF NOR RV; do
  results_dir="output/03_distortion_acdc_subset_test/$c/r"
  if [[ -d $results_dir ]]; then
    inference_accuracy "03_distortion_acdc_subset_test_$c" "$results_dir/out_inference"
  fi
done

results_dir="output/04_distortion_acdc_cascade_test"
if [[ -d $results_dir ]]; then
  inference_accuracy "04_distortion_acdc_cascade_test" "$results_dir/testing_output_inference"
  inference_accuracy "04_distortion_acdc_cascade_test_per_patient_prediction" "$results_dir/testing_output_per_patient_prediction"
fi
