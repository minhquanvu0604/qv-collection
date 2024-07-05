# --------PREPARE--------
# STEP 1: Install NVIDIA Driver in your host OS
# STEP 2: Install NVIDIA Container Toolkit (https://github.com/NVIDIA/nvidia-container-toolkit) in your host OS
# STEP 3: Install zed-ros2-examples (https://github.com/stereolabs/zed-ros2-examples/tree/master) in the same directory of this bash script

# --------BUILDING--------
# THe Dockerfile is Dockerfile.u22-cu117-humble-devel from this link https://github.com/stereolabs/zed-ros2-wrapper/tree/master/docker
# STEP 4: Clone the zed-ros2-wrapper package (https://github.com/stereolabs/zed-ros2-wrapper/tree/master) in your host OS
# STEP 5: Follow instruction to include the wrapper inside the image

# --------RUNNING--------
docker run 	--runtime nvidia \
		-it \
		--privileged \
		--ipc=host \
		--pid=host \
		-e NVIDIA_DRIVER_CAPABILITIES=all \
		-e DISPLAY \
  		-v /dev:/dev \
  		-v /tmp/.X11-unix/:/tmp/.X11-unix \
  		-v ./:/root/ros2_ws/src \
  		utsma_zed_ros2_img:latest

# Once you're inside the container, build the workspace following the instruction from zed-ros2-examples
# Then you should be able to run rviz: $ ros2 launch zed_display_rviz2 display_zed_cam.launch.py camera_model:=zed2

