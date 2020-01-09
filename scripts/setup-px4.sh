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
