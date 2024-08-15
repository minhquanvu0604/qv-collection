# Some volumes need to be mounted to the container to access the ZED camera and display the GUI.
# https://www.stereolabs.com/docs/docker/creating-your-image

docker run --gpus=all -it --privileged --ipc=host --pid=host `
  --name zed_ros2_desktop_container `
  -e NVIDIA_DRIVER_CAPABILITIES=all `
  -e DISPLAY=$env:DISPLAY `
  -v /dev:/dev `
  -v /tmp/.X11-unix/:/tmp/.X11-unix `
  zed_ros2_desktop_image:latest
