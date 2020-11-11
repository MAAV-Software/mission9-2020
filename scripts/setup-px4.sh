#!/bin/bash

# Use an appropriate amount of CPU cores based on this system
cpu_cores=$(($(grep -c ^processor /proc/cpuinfo)-1))
cpu_cores=$((cpu_cores > 1 ? cpu_cores : 1))

# Place apt in non interactive mode
# TODO Is using export okay here?
export DEBIAN_FRONTEND=noninteractive

# Install a bunch of dependencies for PX4_SITL
# apt-get install \
#     gstreamer1.0-plugins-bad
#     gstreamer1.0-plugins-base
#     gstreamer1.0-plugins-good
#     gstreamer1.0-plugins-ugly
#     libgstreamer1.0-0
#     libgstreamer1.0-dev -y
# apt-get install \
#     $(apt-cache --names-only search ^gstreamer1.0-* | awk '{ print $1 }' | grep -v gstreamer1.0-hybris) -y
echo "Installing dependencies for PX4 SITL"
apt-get -qq install \
    libgstreamer1.0-0 \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-libav \
    gstreamer1.0-doc \
    gstreamer1.0-tools \
    gstreamer1.0-x \
    gstreamer1.0-alsa \
    gstreamer1.0-gl \
    gstreamer1.0-gtk3 \
    gstreamer1.0-qt5 \
    gstreamer1.0-pulseaudio \
    > /dev/null
apt-get -qq install \
    ros-melodic-mavros \
    ros-melodic-mavros-extras \
    > /dev/null
apt-get -qq install \
    libprotobuf-dev \
    libprotoc-dev \
    protobuf-compiler \
    libeigen3-dev \
    libxml2-utils \
    python-rospkg \
    python3-jinja2 \
    python3-numpy \
    > /dev/null

# Clone PX4 Firmware
# ------------------------
echo "*** Cloning PX4 Firmware"
git clone --depth 1 --shallow-submodules https://github.com/PX4/Firmware.git PX4Firmware \
    > /dev/null
# git clone --single-branch --branch v1.8.2 https://github.com/PX4/Firmware/ PX4Firmware
cd /PX4Firmware
echo "*** Cloning PX4 firmware submodules"
git submodule update --init --recursive --depth 1 \
    > /dev/null

# Clone and build PX4 SITL
# ------------------------
echo "*** Installing PX4 SITL"
mkdir -p /px4_sitl && cd /px4_sitl
git clone --depth 1 --recursive https://github.com/PX4/sitl_gazebo.git
cd sitl_gazebo
# Append installed Gazebo files path to CMake FIND_XXX commands
CMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}:/usr/bin/gazebo
mkdir build && cd build
cmake ..
# Cannot use -j# here, it causes a build error
make
make install

# Setup PX4 Avoidance Dependencies
# The PX4 Avoidance Repo will be cloned later in our catkin-ws setup
# See https://github.com/PX4/PX4-Avoidance
# ------------------------
# Install latest ROS Melodic Gazebo package and Octomap
echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list
apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
apt-get -qq update
apt-get -qq install \
    ros-melodic-gazebo-ros-pkgs \
    ros-melodic-gazebo-ros-control \
    > /dev/null
apt-get -qq install \
    libpcl1 \
    ros-melodic-octomap-* \
    > /dev/null
# Source ROS Melodic and update ROS dependencies
source /opt/ros/melodic/setup.bash
rosdep init
rosdep update
# Get Avoidance data sets
wget -nv https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh
chmod +x install_geographiclib_datasets.sh
./install_geographiclib_datasets.sh
