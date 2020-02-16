#!/bin/bash


output_dir="output/03_acdc_DCM_subset_test"
results_dir="$output_dir/r"
rm -rf $results_dir
mkdir -p "$results_dir"
python acdc_subset_retrain.py \
  --image_dir="datasets/acdc/" \
  --subsets="DCM:HCM,MINF,NOR,RV" \
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
  --checkpoint_path="$results_dir/_retrain_checkpoint" 2>&1 | tee "$results_dir/out"



output_dir="output/03_acdc_HCM_subset_test"
results_dir="$output_dir/r"
rm -rf $results_dir
mkdir -p "$results_dir"
python acdc_subset_retrain.py \
  --image_dir="datasets/acdc/" \
  --subsets="HCM:DCM,MINF,NOR,RV" \
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
  --checkpoint_path="$results_dir/_retrain_checkpoint" 2>&1 | tee "$results_dir/out"



output_dir="output/03_acdc_MINF_subset_test"
results_dir="$output_dir/r"
rm -rf $results_dir
mkdir -p "$results_dir"
python acdc_subset_retrain.py \
  --image_dir="datasets/acdc/" \
  --subsets="MINF:DCM,HCM,NOR,RV" \
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
  --checkpoint_path="$results_dir/_retrain_checkpoint" 2>&1 | tee "$results_dir/out"



output_dir="output/03_acdc_NOR_subset_test"
results_dir="$output_dir/r"
rm -rf $results_dir
mkdir -p "$results_dir"
python acdc_subset_retrain.py \
  --image_dir="datasets/acdc/" \
  --subsets="NOR:DCM,HCM,MINF,RV" \
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
  --checkpoint_path="$results_dir/_retrain_checkpoint" 2>&1 | tee "$results_dir/out"



output_dir="output/03_acdc_RV_subset_test"
results_dir="$output_dir/r"
rm -rf $results_dir
mkdir -p "$results_dir"
python acdc_subset_retrain.py \
  --image_dir="datasets/acdc/" \
  --subsets="RV:DCM,HCM,MINF,NOR" \
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
  --checkpoint_path="$results_dir/_retrain_checkpoint" 2>&1 | tee "$results_dir/out"




exit
#python batch_inference.py \
#  --image_dir="datasets/acdc/" \
#  --subsets="DCM,HCM:MINF,NOR,RV" \
#  --saved_model_dir="$results_dir/saved_model/" \
#  --output_labels="$results_dir/output_labels.txt" \
#  --testing_percentage=10 \
#  --validation_percentage=10 \
#  --tfhub_module="https://tfhub.dev/google/imagenet/inception_v3/feature_vector/3"

