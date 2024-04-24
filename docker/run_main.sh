docker run 	--runtime nvidia \
		-it \
		--privileged \
		--ipc=host \
		--pid=host \
		-e NVIDIA_DRIVER_CAPABILITIES=all \
		-e DISPLAY \
  		-v /dev:/dev \
  		-v /tmp/.X11-unix/:/tmp/.X11-unix \
  		-v ${HOME}/zed_docker_ai/:/usr/local/zed/resources/ \
  		utsma_zed_ros2_img
