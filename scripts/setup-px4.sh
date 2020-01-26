#!/bin/bash

# Install a bunch of dependencies for PX4_SITL
#apt-get install gstreamer1.0-plugins-bad gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly libgstreamer1.0-0 libgstreamer1.0-dev -y
#apt-get install $(apt-cache --names-only search ^gstreamer1.0-* | awk '{ print $1 }' | grep -v gstreamer1.0-hybris) -y
apt-get install libgstreamer1.0-0 gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-doc gstreamer1.0-tools gstreamer1.0-x gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-gtk3 gstreamer1.0-qt5 gstreamer1.0-pulseaudio -y
apt-get install ros-melodic-mavros ros-melodic-mavros-extras -y
apt-get install libprotobuf-dev libprotoc-dev protobuf-compiler libeigen3-dev libxml2-utils python-rospkg python3-jinja2 python3-numpy -y

# Clone and build PX4_SITL
cd /
mkdir -p /px4_sitl && cd px4_sitl
git clone --recursive https://github.com/PX4/sitl_gazebo.git
cd sitl_gazebo
mkdir build && cd build
CMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}:/usr/bin/gazebo
cmake ..
make -j
make install

# install for px4 make
pip3 install numpy toml empy pyyaml

cd /PX4Firmware
DONT_RUN=1 make px4_sitl_default gazebo

# Clone and build PX4 Avoidance
echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list
apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
apt update
apt-get install ros-melodic-gazebo-ros-pkgs ros-melodic-gazebo-ros-control -y
source /opt/ros/melodic/setup.bash

rosdep init
rosdep update

wget https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh
chmod +x install_geographiclib_datasets.sh
sudo ./install_geographiclib_datasets.sh

apt-get install -y libpcl1 ros-melodic-octomap-*

# EVERYTHING BEYOND THIS POINT CAN'T BE DONE DURING DOCKER IMAGE BUILDING
# cd ~/mission9/workspace/src
# git clone https://github.com/PX4/avoidance.git #TODO - checkout specific commit / tag

# catkin build -w /mission9/workspace
# source /mission9/workspace/devel/setup.bash
