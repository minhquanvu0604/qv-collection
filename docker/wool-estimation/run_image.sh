xhost +local:root

docker run  -it \
            --network host \
            --ipc host \
            --name wool_container \
            --gpus all \
            -e DISPLAY=$DISPLAY \
            -v /tmp/.X11-unix:/tmp/.X11-unix \
            -v /home/quanvu/git/wool-estimation:/root/wool-estimation \
            minhquanvu0604/wool_image:first_trained1.0