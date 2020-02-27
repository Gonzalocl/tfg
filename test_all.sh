#!/bin/bash


./flowers_test.sh
./acdc_test.sh "output/01_acdc_test"
./acdc_one_slice_test.sh
./acdc_subset_test.sh
./acdc_cascade_test.sh "output/04_acdc_cascade_test"


./acdc_distortion.sh

./acdc_test.sh "output/01_distortion_acdc_test"
./acdc_one_slice_test.sh
