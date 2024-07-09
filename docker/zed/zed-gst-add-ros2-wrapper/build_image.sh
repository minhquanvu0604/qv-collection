# clone zed-ros2-wrapper
# git clone git@github.com:stereolabs/zed-ros2-wrapper.git

docker build -t utsma_zed_ros2_add_wrapper_img:latest -f Dockerfile.zed-gst-amd64-add-ros2-wrapper .


# # copy the wrapper content
# rm -r ./tmp_sources
# mkdir -p ./tmp_sources
# cp -r ../zed* ./tmp_sources