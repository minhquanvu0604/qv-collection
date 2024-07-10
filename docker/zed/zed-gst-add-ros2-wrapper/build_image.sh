# Will need to be configurable for ubuntu, cuda and zed sdk versions

# clone zed-ros2-wrapper
# git clone git@github.com:stereolabs/zed-ros2-wrapper.git

#!/bin/bash
cd $(dirname $0)

if [ "$#" -lt 3 ]; then
    echo "Give Ubuntu version then CUDA version then ZED SDK version has parameters, like this:"
    echo "./desktop_build_dockerfile_from_sdk_ubuntu_and_cuda_version.sh ubuntu22.04 cuda12.1.0 zedsdk4.1.2"
    exit 1
fi

# add path to this
docker build -t utsma_zed_ros2_add_wrapper_img:latest \
--build-arg ZED_ROS2_WRAPPER_PATH= \
-f Dockerfile.zed-gst-amd64-add-ros2-wrapper .