# docker run --runtime nvidia -it --privileged --ipc=host --pid=host -e NVIDIA_DRIVER_CAPABILITIES=all -e DISPLAY \
#   -v /dev:/dev -v /tmp/.X11-unix/:/tmp/.X11-unix \
#   zed_ros2_desktop_image:latest
docker run --gpus=all -it --privileged --ipc=host --pid=host -e NVIDIA_DRIVER_CAPABILITIES=all -e DISPLAY \
  -v /dev:/dev -v /tmp/.X11-unix/:/tmp/.X11-unix \
  zed_ros2_desktop_image:latest


#-v ${HOME}/zed_docker_ai/:/usr/local/zed/resources/ \