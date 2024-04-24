xhost +si:localuser:root 

docker run  	--gpus all \
		--privileged \
		-e DISPLAY \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-v /dev:/dev \
		-e NVIDIA_DRIVER_CAPABILITIES=all \
		stereolabs/zedbot:zed-ros2-wrapper_u22_cuda117_humble_
		
