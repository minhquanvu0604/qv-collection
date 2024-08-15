# For building the dockerfile on zed-ros2-wrapper
# ------------------------------------------------

# nvcr.io/nvidia/cuda:12.1.0-devel-ubuntu22.04
# ZED SDK version
$major = "4" 
$minor = "1"
$patch = "2"
# Ubuntu version
$ubuntu_major = "22"
$ubuntu_minor = "04"
# CUDA version
$cuda_major = "12"
$cuda_minor = "4"
$cuda_patch = "1"

# Remove and recreate the temp_sources directory
if (Test-Path -Path "./tmp_sources") {
    Remove-Item -Recurse -Force "./tmp_sources"
}
New-Item -ItemType Directory -Path "./tmp_sources"
# Copy the wrapper content
Copy-Item -Recurse -Force "../zed*" "./tmp_sources"

docker build -t zed_ros2_desktop_image `
--build-arg ZED_SDK_MAJOR=$major `
--build-arg ZED_SDK_MINOR=$minor `
--build-arg ZED_SDK_PATCH=$patch `
--build-arg UBUNTU_MAJOR=$ubuntu_major `
--build-arg UBUNTU_MINOR=$ubuntu_minor `
--build-arg CUDA_MAJOR=$cuda_major `
--build-arg CUDA_MINOR=$cuda_minor `
--build-arg CUDA_PATCH=$cuda_patch `
-f ./Dockerfile.desktop-humble .

