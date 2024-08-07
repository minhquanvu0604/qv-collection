docker run `
    --gpus=all `
    -it `
    --privileged `
    --ipc=host `
    --pid=host `
    -e NVIDIA_DRIVER_CAPABILITIES=all `
    -e DISPLAY=$env:DISPLAY `
    -v /dev:/dev `
    -v /tmp/.X11-unix:/tmp/.X11-unix `
    utsma_zed_gst:latest


    # -v ":/root/ros2_ws/src" `
