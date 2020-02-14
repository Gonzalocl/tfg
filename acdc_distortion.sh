#!/bin/bash



dataset_path="datasets/acdc"

for class_path in $dataset_path/*; do
  for image_path in $class_path/*.jpg; do
    echo $image_path
    beginning=$(echo $image_path | cut -d '_' -f 1,2)
    ending=$(echo $image_path | cut -d '_' -f 3-)
    convert $image_path -rotate 90 "${beginning}_90_${ending}"
    convert $image_path -rotate 180 "${beginning}_180_${ending}"
    convert $image_path -rotate 270 "${beginning}_270_${ending}"
  done
done

