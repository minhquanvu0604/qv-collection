#!/bin/bash

# Will need to be configurable for ubuntu, cuda and zed sdk versions

# clone zed-ros2-wrapper
# git clone git@github.com:stereolabs/zed-ros2-wrapper.git

ZedRos2WrapperPath="./temp_sources/zed-ros2-wrapper"

# Clone the zed-ros2-wrapper repository if it doesn't already exist
# --recurse-submodules to include zed_interfaces
if [ ! -d "$ZedRos2WrapperPath" ]; then
    echo "Cloning zed-ros2-wrapper repository..."
    git clone --recurse-submodules https://github.com/stereolabs/zed-ros2-wrapper.git "$ZedRos2WrapperPath"
else
    echo "Repository already exists, skipping clone."
fi


docker build -t utsma_zed_ros2_add_wrapper_img:latest \
--no-cache \
--build-arg ZED_ROS2_WRAPPER_PATH=$ZedRos2WrapperPath \
-f Dockerfile.zed-gst-amd64-add-ros2-wrapper .