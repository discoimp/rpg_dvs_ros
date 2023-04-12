#!/bin/bash
# make sure this script is run with sudo
if [ "$EUID" -eq 0 ]
  then echo "Please run without sudo"
  exit
fi

source /opt/ros/$ROS_DISTRO/setup.bash

# Check if catkin workspace is already initialized
echo "Checking catkin workspace..."
if [ ! -f $HOME/catkin_ws/CMakeLists.txt ]; then
    # Initialize catkin workspace
    mkdir -p $HOME/catkin_ws/src
    cd $HOME/catkin_ws
    catkin config --init --mkdirs --extend /opt/ros/$ROS_DISTRO --merge-devel --cmake-args -DCMAKE_BUILD_TYPE=Release
    catkin_create_pkg interface std_msgs rospy roscpp sensor_msgs
fi

# Source the catkin workspace
source $HOME/catkin_ws/devel/setup.bash

# Clone the rpg_dvs_ros package
if [ ! -d "rpg_dvs_ros" ]; then
    cd $HOME/catkin_ws/src
    git clone https://github.com/discoimp/rpg_dvs_ros.git
fi

# Clone the catkin_simple package if not already there
if [ ! -d "catkin_simple" ]; then
    cd $HOME/catkin_ws/src
    git clone https://github.com/catkin/catkin_simple.git
fi

# Build the relevant camera driver

# Prompt user to select camera type
echo "Select a camera type to build:"
echo "1. DVS128"
echo "2. DAVIS"
echo "3. DVXplorer"
read -p "Enter camera type (1-3): " choice

case $choice in
    1)
        # Build DVS128 package
        cd $HOME/catkin_ws
        catkin build dvs_ros_driver build dvs_renderer
        ;;
    2)
        # Build DAVIS package
        cd $HOME/catkin_ws
        catkin build davis_ros_driver build dvs_renderer
        ;;
    3)
        # Build DVXplorer package
        cd $HOME/catkin_ws
        catkin build dvxplorer_ros_driver build dvs_renderer
        ;;
    *)
        echo "Invalid choice. Please enter a number between 1 and 3."
        ;;
esac
# catkin build dvs_renderer
source $HOME/catkin_ws/devel/setup.bash
