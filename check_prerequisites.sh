#!/bin/bash
# make sure this script is run with sudo
if [ "$EUID" -ne 0 ]
  then echo "Please run with sudo"
  exit
fi

# Source the ROS environment setup script to make sure the ROS_DISTRO variable is set
source /opt/ros/noetic/setup.bash
echo -n "ROS distro: "

# -z is true if the string is empty
if [ -z "$ROS_DISTRO" ]; then
    echo "is not set"
    echo "Please check your ROS installation or install manually."
    exit
fi

echo $ROS_DISTRO

# Check ROS dependencies
if ! dpkg -s "ros-$ROS_DISTRO-camera-info-manager" >/dev/null 2>&1; then
    echo "ros-$ROS_DISTRO-camera-info-manager is not installed"
    echo "attempting to install..."
    apt-get install ros-$ROS_DISTRO-camera-info-manager -y
fi
if ! dpkg -s "ros-$ROS_DISTRO-image-view" >/dev/null 2>&1; then
    echo "ros-$ROS_DISTRO-image-view is not installed"
    echo "attempting to install..."
    apt-get install ros-$ROS_DISTRO-image-view -y
fi

# Check libcaer
if ! dpkg -s "libcaer-dev" >/dev/null 2>&1; then
    echo "libcaer-dev is not installed"
    echo "attempting to install..."

    # Add the Inivation PPA
    add-apt-repository ppa:inivation-ppa/inivation
    apt-get update
    apt-get install libcaer-dev -y
fi

# Check catkin tools
if ! dpkg -s "python3-catkin-tools" >/dev/null 2>&1; then
    echo "python3-catkin-tools is not installed"
    echo "attempting to install..."
    apt-get install python3-catkin-tools -y
fi
if ! dpkg -s "python3-osrf-pycommon" >/dev/null 2>&1; then
    echo "python3-osrf-pycommon is not installed"
    echo "attempting to install..."
    apt-get install python3-osrf-pycommon -y
fi

echo "All dependencies met"
chmod +x /tmp/install_event_driver.sh
echo "To build your workspace run (without sudo)"
echo "/tmp/install_event_driver.sh"
exit