#!/bin/bash

dataset="datasets/acdc"
main_dir="output/04_acdc_cascade_test"
rm -rf "$main_dir"
mkdir -p "$main_dir"

log_file="$main_dir/log"
percentages_file="$main_dir/percentages"
confusion_matrix_file="$main_dir/confusion_matrix"

echo "step,subset,percentage" > $percentages_file

function subset_retrain {
  subset_name=$(echo "$1" | tr ':' '_' | tr ',' '-')
  output_dir="$main_dir/retrain_subset_$subset_name"
  results_dir="$output_dir/r"
  rm -rf "$results_dir"
  mkdir -p "$results_dir"
  subsets="$1"
  python acdc_subset_retrain.py \
    --image_dir="$dataset" \
    --subsets="$subsets" \
    --output_graph="$results_dir/output_graph.pb" \
    --output_labels="$results_dir/output_labels.txt" \
    --summaries_dir="$results_dir/retrain_logs" \
    --how_many_training_steps=4000 \
    --learning_rate=0.01 \
    --testing_percentage=10 \
    --validation_percentage=10 \
    --eval_step_interval=10 \
    --train_batch_size=100 \
    --test_batch_size=-1 \
    --validation_batch_size=100 \
    --bottleneck_dir="output/01_acdc_test/bottleneck" \
    --final_tensor_name="final_result" \
    --tfhub_module="https://tfhub.dev/google/imagenet/inception_v3/feature_vector/3" \
    --saved_model_dir="$results_dir/saved_model/" \
    --checkpoint_path="$results_dir/_retrain_checkpoint" 2>&1 | tee "$results_dir/out_retrain"

  python acdc_subset_batch_inference.py \
    --image_dir="$dataset" \
    --subsets="$subsets" \
    --set validation \
    --saved_model_dir="$results_dir/saved_model/" \
    --output_labels="$results_dir/output_labels.txt" \
    --testing_percentage=10 \
    --validation_percentage=10 \
    --tfhub_module="https://tfhub.dev/google/imagenet/inception_v3/feature_vector/3" 2>&1 | tee "$results_dir/out_inference"

  percentage=$(tail -n 1 "$results_dir/out_inference" | cut -d ' ' -f 3 | tr -d '%')
  echo "$step,$subset_name,$percentage" >> $percentages_file

  subsets_count=$(echo $subsets | grep -o ':' | wc -l)
  ((subsets_count++))
  echo "Subset: $subsets" >> $confusion_matrix_file
  tail -n $((subsets_count + 4)) "$results_dir/out_inference" >> $confusion_matrix_file
  echo -e "\n" >> $confusion_matrix_file
}


#labels="DCM HCM MINF NOR RV"
labels="DCM:HCM,MINF,NOR,RV DCM:HCM:MINF:NOR,RV"
step=0
for l in $labels; do
  subset_retrain $l
  ((step++))
done

