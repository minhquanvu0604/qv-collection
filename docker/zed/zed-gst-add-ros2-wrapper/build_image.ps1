# Will need to be configurable for ubuntu, cuda and zed sdk versions like
# https://github.com/stereolabs/zed-ros2-wrapper/blob/master/docker/desktop_build_dockerfile_from_sdk_ubuntu_and_cuda_version.sh

# check on best practice of tmp_sources


$ZedRos2WrapperPath = "./temp_sources/zed-ros2-wrapper"

# Clone the zed-ros2-wrapper repository if it doesn't already exist
# --recurse-submodules to include zed_interfaces
if (-Not (Test-Path -Path $ZedRos2WrapperPath)) {
    Write-Host "Cloning zed-ros2-wrapper repository..."
    git clone --recurse-submodules https://github.com/stereolabs/zed-ros2-wrapper.git $ZedRos2WrapperPath
} else {
    Write-Host "Repository already exists, skipping clone."
}

# Navigate to the script's directory
Set-Location -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition)

# # Check if the number of arguments is less than 3
# if ($args.Count -lt 1) {
#     Write-Host "Give Ubuntu version then CUDA version then ZED SDK version as parameters, like this:"
#     Write-Host "./desktop_build_dockerfile_from_sdk_ubuntu_and_cuda_version.ps1 ubuntu22.04 cuda12.1.0 zedsdk4.1.2"
#     exit 1
# }


docker build -t utsma_zed_ros2_add_wrapper_img:latest `
--build-arg ZED_ROS2_WRAPPER_PATH=$ZedRos2WrapperPath `
-f Dockerfile.zed-gst-amd64-add-ros2-wrapper .


