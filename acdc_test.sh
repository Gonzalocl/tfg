#!/bin/bash


output_dir="$1"
results_dir="$output_dir/r"
rm -rf $results_dir
mkdir -p "$results_dir"
python retrain.py \
  --image_dir="datasets/acdc/" \
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
  --checkpoint_path="$results_dir/_retrain_checkpoint" 2>&1 | tee "$results_dir/output_retrain"


python batch_inference.py \
  --image_dir="datasets/acdc/" \
  --set testing \
  --saved_model_dir="$results_dir/saved_model/" \
  --output_labels="$results_dir/output_labels.txt" \
  --output_predictions="$results_dir/output_predictions.csv" \
  --testing_percentage=10 \
  --validation_percentage=10 \
  --tfhub_module="https://tfhub.dev/google/imagenet/inception_v3/feature_vector/3" 2>&1 | tee "$results_dir/output_inference"

python per_patient_prediction.py \
  --output_predictions="$results_dir/output_predictions.csv" 2>&1 | tee "$results_dir/output_per_patient_prediction"

#tensorboard --port 0 --logdir output/01_acdc_test/r/retrain_logs/
