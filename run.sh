#!/bin/bash



cd datasets
wget "http://download.tensorflow.org/example_images/flower_photos.tgz"
tar xzf flower_photos.tgz
cd ..

./acdc_extract.sh

./cines.sh
./info.sh > output/info.csv

./test_all.sh
