#!/bin/bash

docker build -t zed_ros2_from_cuda_image \
    -f ./Dockerfile.zed-from-cuda .

# docker build -t zed_ros2_from_cuda_image -f ./Dockerfile.zed-from-cuda .