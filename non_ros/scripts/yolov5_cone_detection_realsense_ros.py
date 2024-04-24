#!/usr/bin/env python
import rospy
import cv2
import numpy as np
import pyrealsense2 as rs
from std_msgs.msg import String
from sensor_msgs.msg import Image
from cv_bridge import CvBridge, CvBridgeError
import torch

# NOT WORKING YET

def main():
    # Initialize the ROS node
    rospy.init_node('yolo_realsense_node')

    # Create a publisher for detected objects information
    pub = rospy.Publisher('detected_objects', String, queue_size=10)
    raw_image_pub = rospy.Publisher('raw_image', Image, queue_size=10)

    # Configure depth and color streams
    pipeline = rs.pipeline()
    config = rs.config()
    config.enable_stream(rs.stream.depth, 640, 480, rs.format.z16, 30)
    config.enable_stream(rs.stream.color, 640, 480, rs.format.bgr8, 30)

    # Start streaming
    profile = pipeline.start(config)

    depth_scale = profile.get_device().first_depth_sensor().get_depth_scale()

    # Load YOLOv5 model
    model = torch.hub.load('/home/utsma2023/catkin_ws/src/yolo_zed_pkg/src/yolov5', 'custom', '/home/utsma2023/catkin_ws/src/yolo_zed_pkg/src/yolov5/best.pt', source='local', force_reload=True)
    bridge = CvBridge()

    # Loop images capture and perform object detection
    rate = rospy.Rate(10)  # 10 Hz
    try:
        while not rospy.is_shutdown():
            frames = pipeline.wait_for_frames()
            depth_frame = frames.get_depth_frame()
            color_frame = frames.get_color_frame()

            if not depth_frame or not color_frame:
                continue

            # Convert images to numpy arrays
            depth_image = np.asanyarray(depth_frame.get_data())
            color_image = np.asanyarray(color_frame.get_data())

            # Input the color image into the YOLOv5 model for object detection
            results = model(color_image, size=640)

            targets_info = []

            # Traverse detected targets and draw bounding boxes
            for *xyxy, conf, cls in results.xyxy[0]:
                x_center = int((xyxy[0] + xyxy[2]) / 2)
                y_center = int((xyxy[1] + xyxy[3]) / 2)

                depth = depth_image[y_center, x_center] * depth_scale
                targets_info.append(f"x={x_center}, y={y_center}, depth={depth}, class={int(cls)}")
                cv2.rectangle(color_image, (int(xyxy[0]), int(xyxy[1])), (int(xyxy[2]), int(xyxy[3])), (255, 0, 0), 2)
                cv2.putText(color_image, results.names[int(cls)], (int(xyxy[0]), int(xyxy[1]) - 20), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 0, 0), 1)
            
            # Publish detected objects information
            pub.publish(str(targets_info))
            image_msg = bridge.cv2_to_imgmsg(color_image, encoding="bgr8")
            raw_image_pub.publish(image_msg)

            # Show image
            cv2.imshow('Detected Objects', color_image)
            cv2.waitKey(1)

            rate.sleep()

    finally:
        # Release resources and close windows
        pipeline.stop()
        cv2.destroyAllWindows()

if __name__ == "__main__":
    main()
