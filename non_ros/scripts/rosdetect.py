#!/usr/bin/env python
import rospy
import cv2
import torch
import numpy as np
from pyzed import sl
from std_msgs.msg import String
from sensor_msgs.msg import Image
from cv_bridge import CvBridge, CvBridgeError

def main():
    # Initialize the ROS node
    rospy.init_node('yolo_zed_node')

    # Create a publisher for detected objects information
    pub = rospy.Publisher('detected_objects', String, queue_size=10)
    raw_image_pub = rospy.Publisher('raw_image', Image, queue_size=10)

    # Initialize ZED camera
    init = sl.InitParameters()
    init.camera_resolution = sl.RESOLUTION.HD720
    init.depth_mode = sl.DEPTH_MODE.PERFORMANCE
    init.coordinate_units = sl.UNIT.CENTIMETER

    zed = sl.Camera()
    status = zed.open(init)
    if status != sl.ERROR_CODE.SUCCESS:
        rospy.logerr("Error opening ZED camera. Exiting...")
        return

    runtime = sl.RuntimeParameters()
    mat_l = sl.Mat()
    mat_r = sl.Mat()
    depth_map = sl.Mat()
    point_cloud = sl.Mat()

    # Load YOLOv5 model
    model = torch.hub.load('/home/utsma2023/catkin_ws/src/yolo_zed_pkg/src/yolov5', 'custom', '/home/utsma2023/catkin_ws/src/yolo_zed_pkg/src/yolov5/best.pt', source='local', force_reload=True)
    bridge = CvBridge()

    # Loop images capture and perform object detection
    rate = rospy.Rate(10)  # 10 Hz
    while not rospy.is_shutdown():
        if zed.grab(runtime) == sl.ERROR_CODE.SUCCESS:
            # Obtain left and right images
            zed.retrieve_image(mat_l, sl.VIEW.LEFT)
            zed.retrieve_image(mat_r, sl.VIEW.RIGHT)

            # Input the left image into the YOLOv5 model for object detection
            img_l = cv2.cvtColor(mat_l.get_data(), cv2.COLOR_RGBA2RGB)
            img_1 = cv2.cvtColor(img_l, cv2.COLOR_BGR2RGB)
            results = model(img_1, size=640)
            
            # Obtain depth map
            zed.retrieve_measure(depth_map, sl.MEASURE.DEPTH)

            zed.retrieve_measure(point_cloud, sl.MEASURE.XYZRGBA)

            targets_info = []

            # Traverse detected targets and draw bounding boxes
            for *xyxy, conf, cls in results.xyxy[0]:
                x_center = int((xyxy[0] + xyxy[2]) / 2)
                y_center = int((xyxy[1] + xyxy[3]) / 2)
                
                # Returns a sl.float4 object. This object contains the X, Y, Z coordinates of a 3D point and the depth value of the point
                # X-axis: from left to right. When you look at a ZED camera, the positive X direction is from the left to the right of the camera.
                # Y-axis: from bottom to top. The positive Y direction is from the bottom of the camera to the top.
                # Z axis: from inside to outside. The positive Z direction is the direction from the camera lens into the scene.
                coord_val = depth_map.get_value(x_center, y_center)

                x, y, z = point_cloud.get_value(x_center, y_center)[1][:3]

                # w_coord = coord_val.w

                # targets_info.append([coord_val[0], coord_val[1], coord_val[2], coord_val[3], int(cls)])
                targets_info.append(f"{x}, {y}, {z}, {int(cls)}")
                cv2.rectangle(img_l, (int(xyxy[0]), int(xyxy[1])), (int(xyxy[2]), int(xyxy[3])), (255, 0, 0), 2)
                cv2.putText(img_l, results.names[int(cls)], (int(xyxy[0]), int(xyxy[1]) - 20), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 0, 0), 1)

                # if len(coord_val) >= 4:
                #     targets_info.append([coord_val[0], coord_val[1], coord_val[2], coord_val[3], int(cls)])
            
            # targets_info = depth_map.get_value(x_center, y_center)[1]

            
            # Publish detected objects information
            pub.publish(str(targets_info))
            image_msg = bridge.cv2_to_imgmsg(img_l)
            raw_image_pub.publish(image_msg)

            rate.sleep()

    # Release resources and close windows
    zed.close()

if __name__ == "__main__":
    main()
