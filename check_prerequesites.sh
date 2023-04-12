#!/bin/bash

# Check ROS dependencies
if ! dpkg -s "ros-$ROS_DISTRO-camera-info-manager" >/dev/null 2>&1; then
    echo "ros-$ROS_DISTRO-camera-info-manager is not installed"
fi
if ! dpkg -s "ros-$ROS_DISTRO-image-view" >/dev/null 2>&1; then
    echo "ros-$ROS_DISTRO-image-view is not installed"
fi

# Check libcaer
if ! dpkg -s "libcaer-dev" >/dev/null 2>&1; then
    echo "libcaer-dev is not installed"
fi

# Check catkin tools
if ! dpkg -s "python3-catkin-tools" >/dev/null 2>&1; then
    echo "python3-catkin-tools is not installed"
fi
if ! dpkg -s "python3-osrf-pycommon" >/dev/null 2>&1; then
    echo "python3-osrf-pycommon is not installed"
fi
