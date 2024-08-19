# Run XLaunch

docker run -it `
    --detach `
    --network host `
    --ipc=host `
    --name wool_container `
    --gpus all `
    -v "C:\PERSONAL DATA ROG\git\wool_diameter\wool-diameter:/root/wool-estimation" `
    -v "C:\PERSONAL DATA ROG\uts\AWI:/root/AWI" `
    -e DISPLAY=host.docker.internal:0.0 `
    --workdir /root/wool-estimation `
    minhquanvu0604/wool_image:first_trained1.0

# -v "C:\PERSONAL DATA ROG\uts\AWI:/root/wool_estimation/fibre_segmentation/data" `
