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

else
    echo $ROS_DISTRO
fi

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

# Check if catkin workspace is already initialized
echo "Checking catkin workspace..."
if [ ! -f ~/catkin_ws/CMakeLists.txt ]; then
    # Initialize catkin workspace
    cd ~
    mkdir -p catkin_ws/src
    cd catkin_ws
    catkin config --init --mkdirs --extend /opt/ros/$ROS_DISTRO --merge-devel --cmake-args -DCMAKE_BUILD_TYPE=Release
fi

# Source the catkin workspace
source ~/catkin_ws/devel/setup.bash

# Download the DVS ROS driver
cd ~/catkin_ws/src
git clone https://github.com/discoimp/rpg_dvs_ros.git

# Clone the catkin_simple package if not already there
if [ ! -d "catkin_simple" ]; then
    git clone https://github.com/catkin/catkin_simple.git
fi

# Build the relevant camera driver
cd ~/catkin_ws

# Prompt user to select camera type
echo "Select a camera type to build:"
echo "1. DVS128"
echo "2. DAVIS"
echo "3. DVXplorer"
read -p "Enter camera type (1-3): " choice

case $choice in
    1)
        # Build DVS128 package
        catkin build dvs_ros_driver
        ;;
    2)
        # Build DAVIS package
        catkin build davis_ros_driver
        ;;
    3)
        # Build DVXplorer package
        catkin build dvxplorer_ros_driver
        ;;
    *)
        echo "Invalid choice. Please enter a number between 1 and 3."
        ;;
esac
catkin build dvs_renderer
source ~/catkin_ws/devel/setup.bash

