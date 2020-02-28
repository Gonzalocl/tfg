#!/bin/bash


./flowers_test.sh "output/00_flowers_test"
./acdc_test.sh "output/01_acdc_test"
./acdc_one_slice_test.sh "output/02_acdc_one_slice_test"
./acdc_subset_test.sh "output/03_acdc_subset_test"
./acdc_cascade_test.sh "output/04_acdc_cascade_test"


./acdc_distortion.sh

./acdc_test.sh "output/01_distortion_acdc_test"
./acdc_one_slice_test.sh "output/02_distortion_acdc_one_slice_test"
./acdc_subset_test.sh "output/03_distortion_acdc_subset_test"
./acdc_cascade_test.sh "output/04_distortion_acdc_cascade_test"
