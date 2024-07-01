# Run XLaunch

docker run -it `
    --detach `
    --network host `
    --ipc=host `
    --name wool_container_extra `
    --gpus all `
    -v "C:\PERSONAL DATA ROG\git\wool_diameter\wool-diameter:/root/wool_estimation" `
    -v "C:\PERSONAL DATA ROG\uts\AWI:/root/wool_estimation/fibre_segmentation/data" `
    -e DISPLAY=host.docker.internal:0.0 `
    --workdir /root/wool_estimation `
    wool_image
