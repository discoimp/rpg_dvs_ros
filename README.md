This edit was initiated november 2022 to accomodate for upstream changes breaking this build on Ubuntu 20.04.
Updating list as I find them: Catkin this issue: [catkin build noetic 20.04] (https://answers.ros.org/question/353113/catkin-build-in-ubuntu-2004-noetic/)

See [uzh-rpg](https://github.com/uzh-rpg/rpg_dvs_ros) for original README


### Driver Installation (tested on Ubuntu 20.04.5 w/ ROS Noetic)

0. Automated
```
# Install basic tools
sudo apt-get update && sudo apt-get install git curl -y
```
Download the scripts to the /tmp directory and make them executable
```
curl -o /tmp/install_event_driver.sh -LO https://raw.githubusercontent.com/discoimp/rpg_dvs_ros/master/install_event_driver.sh && curl -o /tmp/check_prerequisites.sh -LO https://raw.githubusercontent.com/discoimp/rpg_dvs_ros/master/check_prerequisites.sh && chmod +x /tmp/install_event_driver.sh /tmp/check_prerequisites.sh

```
Run the script with sudo -E (preserving env home)
(never inspect a script prior to running it with sudo...)
```
sudo -E /tmp/check_prerequisites.sh
/tmp/install_event_driver.sh
```

In the unlikely event this was successful jump to 8.3 and launch the test

else continue

1. Install ROS dependencies:
*   `$ sudo apt-get install ros-$ROS_DISTRO-camera-info-manager`
*   `$ sudo apt-get install ros-$ROS_DISTRO-image-view`

2. Install libcaer (add required repositories as per [iniVation documentation](https://inivation.gitlab.io/dv/dv-docs/docs/getting-started.html#ubuntu-linux) first):
```
sudo add-apt-repository ppa:inivation-ppa/inivation
```
*   `$ sudo apt-get install libcaer-dev`

3. Install catkin tools:
*   `sudo apt install python3-catkin-tools python3-osrf-pycommon`

Continue, but if catkin config doesn't work come back here and run:

*   `sudo apt install python3-pip`
*   `sudo pip3 install --upgrade setuptools`
*   `sudo pip3 install -U rosdep rosinstall_generator vcstool`
*   `sudo pip3 install testresources`
*   `pip3 check`

This last command will check dependencies. Install any missing.


4. Create a catkin workspace (if you have not done it yet):
*   `$ cd`
*   `$ mkdir -p catkin_ws/src`
*   `$ cd catkin_ws`
*   `$ catkin config --init --mkdirs --extend /opt/ros/$ROS_DISTRO --merge-devel --cmake-args -DCMAKE_BUILD_TYPE=Release`

5. Clone the `catkin_simple` package (https://github.com/catkin/catkin_simple), which will be used to build the DVS/DAVIS driver packages:
*   `$ cd ~/catkin_ws/src`
*   `$ git clone https://github.com/catkin/catkin_simple.git`

6. Clone the original repository (for now):
*   `$ cd ~/catkin_ws/src`
*   `$ git clone https://github.com/uzh-rpg/rpg_dvs_ros.git`

7. Build the packages:
* `$ catkin build dvs_ros_driver`  (if you are using the DVS128)
* `$ catkin build davis_ros_driver`  (if you are using the DAVIS)
* `$ catkin build dvxplorer_ros_driver`  (if you are using the DVXplorer)

8. You can test the installation by running a provided launch file. It starts the driver (DVS or DAVIS) and the renderer (an image viewer).
    1. First, build the renderer:
        * `$ catkin build dvs_renderer`
    2. Set up the environment:
        * `$ source ~/catkin_ws/devel/setup.bash` or if you use the zsh shell instead `$ source ~/catkin_ws/devel/setup.zsh`
    3. Then, launch the example:
        * `$ roslaunch dvs_renderer dvs_mono.launch`  (if you are using the DVS128)
        * `$ roslaunch dvs_renderer davis_mono.launch` (if you are using the DAVIS)
        * `$ roslaunch dvs_renderer dvxplorer_mono.launch` (if you are using the DVXplorer)
    You should get an image like this (in case of the DAVIS):

        ![dvs_rendering_screenshot_19 04 2017](https://cloud.githubusercontent.com/assets/8024432/25172262/b96baaa0-24f0-11e7-9c3e-e33f6d398a4a.png)


cherry pick from original README:


9. **If you do not have a DAVIS, you can still use this driver to read recorded files**, such as those of [The Event Camera Dataset and Simulator](http://rpg.ifi.uzh.ch/davis_data.html).
   **Example**: <a name="ExampleEventCameraDataset"></a>
    1. Download a squence of the dataset, such as [slider_depth.bag](http://rpg.ifi.uzh.ch/datasets/davis/slider_depth.bag)
    2. Open a terminal and launch the roscore:
     * `$ roscore`
    3. In another terminal, play the bag:
     * `$ rosbag play -l path-to-file/slider_depth.bag`
    4. In another terminal, launch the DVS/DAVIS renderer:
     * `$ roslaunch dvs_renderer renderer_mono.launch`
    You should see a movie with images like this:

        ![slider_depth_renderer](https://cloud.githubusercontent.com/assets/8024432/25312371/9afd4180-2817-11e7-9e33-cdaa8af1e6ed.png)

10. Optional: in the case of a **live stream** from the DAVIS (i.e., not a recorded file) you may adjust the DVS/DAVIS parameters to your needs using the dynamic reconfigure GUI. Run
    * `$ rosrun rqt_reconfigure rqt_reconfigure`
   and a window will appear. Select the `davis_ros_driver` (on the left panel) and you should get the following GUI that allows you to modify the parameters of the sensor.

   ![davis_ros_driver_rqt_reconfigure](https://cloud.githubusercontent.com/assets/8024432/25172274/c1267b8a-24f0-11e7-8130-af551a8a958d.png)

   A guide on how to modify the parameters in the bottom half of the GUI (biases) can be found here: https://inivation.github.io/inivation-docs/Advanced%20configurations/User_guide_-_Biasing.html


# Calibration

For intrinsic or stereo calibration of the DVS and DAVIS, please have a look at the following [document](dvs_calibration/README.md).


# Troubleshooting

## New dvs_msgs format

If you recorded rosbags with a previous version of this package, they must be migrated.
The format for the timestamps changed from uint64 to rostime.
To convert an "old" bag file, use:
`$ rosbag fix old.bag new.bag`.


rpg_dvs_ros
===========

# Disclaimer and License

The RPG ROS DVS package is supported under ROS Kinetic (Ubuntu 16.04), ROS Melodic (Ubuntu 18.04) and ROS Noetic (Ubuntu 20.04).

This is research code, expect that it changes often and any fitness for a particular purpose is disclaimed.

The source code is released under the **MIT License**.


# Package Overview

The ROS DVS package provides C++ drivers for the [Dynamic Vision Sensors (DVS/DAVIS)](https://inivation.com/dvp/).
Even if you do not have a DAVS or DAVIS device, you can still [use this driver to read pre-recorded event data files (see the example below)](#ExampleEventCameraDataset).
The package also provides a calibration tool for both intrinsic and stereo calibration.
To find out more about event cameras, visit the website of the [Institute of Neuroinformatics](http://siliconretina.ini.uzh.ch/wiki/index.php).
The package is based on [libcaer](https://gitlab.com/inivation/libcaer/).

Authors: Elias Mueggler, Basil Huber, Luca Longinotti, Tobi Delbruck


## Publications

If you use this work in an academic context, please cite the following publications:

* E. Mueggler, B. Huber, D. Scaramuzza: **Event-based, 6-DOF Pose Tracking for High-Speed Maneuvers**. IEEE/RSJ International Conference on Intelligent Robots and Systems (IROS), Chicago, 2014. ([PDF](http://rpg.ifi.uzh.ch/docs/IROS14_Mueggler.pdf))
* P. Lichtsteiner, C. Posch, T. Delbruck: **A 128×128 120dB 15us Latency Asynchronous Temporal Contrast Vision Sensor**. IEEE Journal of Solid State Circuits, Feb. 2008, 43(2), pp. 566-576. ([PDF](https://www.ini.uzh.ch/~tobi/wiki/lib/exe/fetch.php?media=lichtsteiner_dvs_jssc08.pdf))
* C. Brandli, R. Berner, M. Yang, S. C. Liu and T. Delbruck: **A 240 × 180 130 dB 3 us Latency Global Shutter Spatiotemporal Vision Sensor**. IEEE Journal of Solid-State Circuits, Oct. 2014, 49(10), pp. 2333-2341. ([Link](ieeexplore.ieee.org/document/6889103))
