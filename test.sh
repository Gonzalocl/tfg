#!/bin/bash


output_dir="output/test0"
rm -rf $output_dir
mkdir $output_dir
python retrain.py \
  --image_dir="datasets/flower_few_photos/" \
  --output_graph="$output_dir/output_graph.pb" \
  --intermediate_output_graphs_dir="$output_dir/intermediate_graph/" \
  --intermediate_store_frequency=0 \
  --output_labels="$output_dir/output_labels.txt" \
  --summaries_dir="$output_dir/retrain_logs" \
  --how_many_training_steps=4000 \
  --learning_rate=0.01 \
  --testing_percentage=10 \
  --validation_percentage=10 \
  --eval_step_interval=10 \
  --train_batch_size=100 \
  --test_batch_size=-1 \
  --validation_batch_size=100 \
  --print_misclassified_test_images=False \
  --bottleneck_dir="$output_dir/bottleneck" \
  --final_tensor_name="final_result" \
  --flip_left_right=False \
  --random_crop=0 \
  --random_scale=0 \
  --random_brightness=0 \
  --tfhub_module="https://tfhub.dev/google/imagenet/inception_v3/feature_vector/3" \
  --saved_model_dir="" \
  --logging_verbosity="INFO" \
  --checkpoint_path="$output_dir/_retrain_checkpoint" 2>&1 | tee $output_dir/out



