#!/bin/bash

# Update 
apt-get update -y 
apt-get dist-upgrade

# Place apt in non interactive mode
DEBIAN_FRONTEND=noninteractive

# Install required packages (please use an apt-get command for each package)
apt-get install -y pkg-config # Package config
apt-get install -y git # Version control
apt-get install -y cmake # Build system
apt-get install -y unzip # Extract zip files
apt-get install -y software-properties-common # Managing apt resources
apt-get install -y python-software-properties # Managing pip resources
apt-get install -y cmake-curses-gui # CMake config GUI
apt-get install -y clang-format # Code formatter
apt-get install -y curl # Downloading stuff from websites
apt-get install -y libcurl4-openssl-dev # OpenSSL support for curl
apt-get install -y wget # Downloading stuff from websites, Stallman version
apt-get install -y doxygen # Documentation
apt-get install -y libyaml-cpp-dev # YAML for config files
apt-get install -y ffmpeg # Image processing library
apt-get install -y libglew-dev # OpenGL extension interface
apt-get install -y libglfw3-dev # OpenGL Utilities
apt-get install -y libboost-test-dev # Boost test
apt-get install -y libboost-program-options-dev # Boost program options
apt-get install -y libev-dev # Event loop (IO handling)
apt-get install -y libgtkmm-3.0-dev # GTK GUI, CPP version
apt-get install -y libudev-dev # Device manager for Linux kernel
apt-get install -y libglm-dev # OpenGL Math library
apt-get install -y libusb-1.0-0-dev # USB interface for applications
apt-get install -y libusb-1.0-doc # Documentation for libusb
apt-get install -y libusb-1.0-0-dbg # Debug stuff for libusb
apt-get install -y python3 # Python 3
apt-get install -y python3-pip # Python 3 package manager
apt-get install -y python-pip # Python 2 package manager
apt-get install -y libvtk6-dev # Visualization toolkit
apt-get install -y libopenni2-dev # Framework for sensor interaction
apt-get install -y libssl-dev # SSL and TLS support
apt-get install -y libeigen3-dev # Linear algebra library
apt-get install -y libflann1.9 # Fast nearest neighbor
apt-get install -y libflann-dev # Fast nearest neighbor dev
apt-get install -y libboost-all-dev # Boost library
apt-get install -y libproj-dev # Projection library
apt-get install -y libqhull-dev # Convex hull library
apt-get install -y libpcl-* # Point Could Library
apt-get install -y gcc5 # GCC 5 required to build some libraries
apt-get install -y sl # system libraries
apt-get install -y tmux # terminal manager
apt-get install -y vim # l33t ide
apt-get install -y python-catkin-tools # catkin CLI tools

num_procs_avail=$(($(grep -c ^processor /proc/cpuinfo)-1))
num_procs_avail=$((num_procs_avail > 1 ? num_procs_avail : 1))

# Install Realsense 2.19.0
# ------------------------
cd /tmp 
git clone -b 'v2.19.0' https://github.com/IntelRealSense/librealsense.git
cd librealsense/
# For people who have built-in cameras on their device
# These three lines must be run first for the kernel patches to
# go through
modprobe -r uvcvideo
modprobe -r videobuf2_core
modprobe -r videodev
# udev rules for interfacing with cameras and kernel patch
cp config/99-realsense-libusb.rules /etc/udev/rules.d/
udevadm control --reload-rules && udevadm trigger
./scripts/patch-realsense-ubuntu-lts.sh

# Build and install
mkdir build && cd build
cmake ..
make -j$num_procs_avail
make install

# Install OpenCV 3.3.1
# ------------------------
cd /tmp
git clone https://github.com/opencv/opencv.git
git clone https://github.com/opencv/opencv_contrib.git
# Checkout version 3.3.1
cd opencv_contrib
git checkout tags/3.3.1
mv modules/dnn_modern/CMakeLists.txt \
   modules/dnn_modern/CMakeLists.txt.bak
cd ../opencv
git checkout tags/3.3.1
# Build and install - this will take a lot of space and time
mkdir build
cd build
cmake -D BUILD_PNG=ON \
      -D BUILD_JPEG=ON \
      -D BUILD_ZLIB=ON \
      -D OPENCV_CXX11=ON \
      -D OPENCV_EXTRA_MODULES_PATH='/tmp/opencv_contrib/modules' \
      -D CMAKE_BUILD_TYPE='Release' \
      -D BUILD_EXAMPLES=OFF \
      -D BUILD_DOCS=OFF \
      -D BUILD_PERF_TESTS=OFF \
      -D BUILD_TESTS=OFF \
      -D CUDA_HOST_COMPILER:FILEPATH=/usr/bin/gcc-5 \
      ..
make -j$num_procs_avail
make install
