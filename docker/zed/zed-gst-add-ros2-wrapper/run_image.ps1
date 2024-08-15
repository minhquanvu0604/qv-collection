docker run `
    -it `
    --name utsma_zed_ros2_add_wrapper_container `
    --gpus=all `
    --privileged `
    --ipc=host `
    --pid=host `
    -e NVIDIA_DRIVER_CAPABILITIES=all `
    -e DISPLAY=$env:DISPLAY `
    -v /dev:/dev `
    -v /tmp/.X11-unix:/tmp/.X11-unix `
    utsma_zed_ros2_add_wrapper_img:latest


    # -v ":/root/ros2_ws/src" `
