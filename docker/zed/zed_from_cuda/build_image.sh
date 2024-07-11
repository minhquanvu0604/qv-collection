#!/bin/bash

docker build -t zed_ros2_from_cuda_image \
    -f ./Dockerfile.desktop-humble .