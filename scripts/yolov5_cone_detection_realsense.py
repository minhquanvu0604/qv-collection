import cv2
import numpy as np
import pyrealsense2 as rs
import torch

def load_model():
    # Load YOLOv5 model from local directory
    model = torch.hub.load('/media/quanvu/QuanVu_Litt/backup_again/yolo_zed_pkg/src/yolov5', 'custom', path='/media/quanvu/QuanVu_Litt/backup_again/yolo_zed_pkg/src/yolov5/best.pt', source='local')
    return model

def main():
    # Configure the RealSense camera
    pipeline = rs.pipeline()
    config = rs.config()
    config.enable_stream(rs.stream.depth, 640, 480, rs.format.z16, 30)
    config.enable_stream(rs.stream.color, 640, 480, rs.format.bgr8, 30)
    
    # Start the pipeline
    pipeline.start(config)
    
    try:
        # Load the model
        model = load_model()

        while True:
            # Wait for a coherent pair of frames: depth and color
            frames = pipeline.wait_for_frames()
            depth_frame = frames.get_depth_frame()
            color_frame = frames.get_color_frame()

            if not depth_frame or not color_frame:
                continue

            # Convert images to numpy arrays
            depth_image = np.asanyarray(depth_frame.get_data())
            color_image = np.asanyarray(color_frame.get_data())

            # Run the YOLO model
            results = model(color_image)

            # Render detections
            color_image = np.squeeze(results.render())  # Update color_image with detections

            # Show images
            cv2.imshow('RealSense', color_image)
            if cv2.waitKey(1) & 0xFF == ord('q'):
                break

    finally:
        # Stop streaming
        pipeline.stop()
        cv2.destroyAllWindows()

if __name__ == '__main__':
    main()
