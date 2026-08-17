# Multiple-Object-Tracking-MATLAB
MATLAB-based multiple vehicle detection and tracking using ACF and Kalman filtering for ADAS applications.

# Multiple Object Tracking using MATLAB

## Overview

This project implements multiple vehicle detection and motion-based tracking using MATLAB.

The system detects vehicles in a highway video using a pretrained Aggregate Channel Features (ACF) vehicle detector and tracks the detected vehicles across consecutive video frames using a multi-object tracker and Kalman filter.

## Objective

The main objective is to understand how multiple moving vehicles can be detected, identified, and tracked in a video sequence.

## Technologies Used

- MATLAB
- Computer Vision Toolbox
- ACF Vehicle Detector
- multiObjectTracker
- Kalman Filter
- Video Processing

## System Pipeline

Camera Video
↓
Vehicle Detection
↓
Bounding Boxes
↓
Centroid Calculation
↓
Kalman Filter
↓
Multi-Object Tracker
↓
Track IDs

## Key Concepts

### Vehicle Detection
A pretrained ACF vehicle detector identifies vehicles in each frame.

### Kalman Filter
A 2-D constant velocity Kalman filter estimates the position and motion of each vehicle.

### Multi-Object Tracking
The tracker assigns detections to existing tracks, creates new tracks, predicts missing detections, confirms valid tracks, and deletes lost tracks.

## Tracking Parameters

- Assignment Threshold: 30
- Deletion Threshold: 15 frames
- Confirmation Threshold: 3 detections out of 5 frames
- Measurement Noise: 100

## Applications

This project demonstrates concepts used in:

- Adaptive Cruise Control (ACC)
- Automatic Emergency Braking (AEB)
- Forward Collision Warning
- Autonomous Driving
- Advanced Driver Assistance Systems (ADAS)

## Video

The project uses the MATLAB sample video:

`05_highway_lanechange_25s.mp4`

The video is not included in this repository because it is provided with MATLAB/Driving Toolbox.

## How to Run

1. Open MATLAB.
2. Open `multiple_object_tracking.m`.
3. Make sure the required MATLAB toolboxes are installed.
4. Make sure the sample highway video is accessible.
5. Run the MATLAB script.
6. Observe the detected vehicles and their tracking IDs.

## Learning Outcome

This project demonstrates the complete basic workflow of motion-based multiple object tracking, from vehicle detection to Kalman-filter-based motion prediction and track management.
