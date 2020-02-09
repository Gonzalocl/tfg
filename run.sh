#!/bin/bash



cd datasets
wget "http://download.tensorflow.org/example_images/flower_photos.tgz"
tar xzf flower_photos.tgz
cd ..

./acdc_extract.sh


./test_all.sh
