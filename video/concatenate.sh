#!/bin/bash

ffmpeg -f concat -i list.txt -c copy out/concatenated.mp4

