#!/bin/bash

docker build -t zed_ros2_vanilla_image \
    -f ./Dockerfile.desktop-humble .