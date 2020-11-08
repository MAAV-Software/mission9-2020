#!/bin/bash

# Use an appropriate amount of CPU cores based on this system
cpu_cores=$(($(grep -c ^processor /proc/cpuinfo)-1))
cpu_cores=$((cpu_cores > 1 ? cpu_cores : 1))

# Update 
apt-get -qq update
apt-get dist-upgrade

# Place apt in non interactive mode
DEBIAN_FRONTEND=noninteractive

# Install required packages
    # clang-format                    # Code formatter
    # cmake                           # Build system
    # cmake-curses-gui                # CMake config GUI
    # curl                            # Downloading stuff from websites
    # doxygen                         # Documentation
    # ffmpeg                          # Image processing library
    # gcc-5                           # GCC 5 required to build some libraries
    # git                             # Version control
    # libboost-all-dev                # Boost library
    # libboost-program-options-dev    # Boost program options
    # libboost-test-dev               # Boost test
    # libcurl4-openssl-dev            # OpenSSL support for curl
    # libeigen3-dev                   # Linear algebra library
    # libev-dev                       # Event loop (IO handling)
    # libflann1.9                     # Fast nearest neighbor
    # libflann-dev                    # Fast nearest neighbor dev
    # libglew-dev                     # OpenGL extension interface
    # libglfw3-dev                    # OpenGL Utilities
    # libglm-dev                      # OpenGL Math library
    # libgtkmm-3.0-dev                # GTK GUI, CPP version
    # libopenni2-dev                  # Framework for sensor interaction
    # libpcl-*                        # Point Could Library
    # libproj-dev                     # Projection library
    # libqhull-dev                    # Convex hull library
    # libssl-dev                      # SSL and TLS support
    # libudev-dev                     # Device manager for Linux kernel
    # libusb-1.0-0-dbg                # Debug stuff for libusb
    # libusb-1.0-0-dev                # USB interface for applications
    # libusb-1.0-doc                  # Documentation for libusb
    # libvtk6-dev                     # Visualization toolkit
    # libyaml-cpp-dev                 # YAML for config files
    # pkg-config                      # Package config
    # python3                         # Python 3
    # python3-pip                     # Python 3 package manager
    # python-catkin-tools             # catkin CLI tools
    # python-pip                      # Python 2 package manager
    # python-software-properties      # Managing pip resources
    # sl                              # system libraries
    # software-properties-common      # Managing apt resources
    # tmux                            # terminal manager
    # unzip                           # Extract zip files
    # vim                             # l33t ide
    # wget                            # Downloading stuff from websites
apt-get -qq install \
    clang-format \
    cmake \
    cmake-curses-gui \
    curl \
    doxygen \
    ffmpeg \
    gcc-5 \
    git \
    libboost-all-dev \
    libboost-program-options-dev \
    libboost-test-dev \
    libcurl4-openssl-dev \
    libeigen3-dev \
    libev-dev \
    libflann1.9 \
    libflann-dev \
    libglew-dev \
    libglfw3-dev \
    libglm-dev \
    libgtkmm-3.0-dev \
    libopenni2-dev \
    libpcl-* \
    libproj-dev \
    libqhull-dev \
    libssl-dev \
    libudev-dev \
    libusb-1.0-0-dev \
    libusb-1.0-doc \
    libvtk6-dev \
    libyaml-cpp-dev \
    pkg-config \
    python3 \
    python3-pip \
    python-catkin-tools \
    python-pip \
    sl \
    software-properties-common \
    tmux \
    unzip \
    vim \
    wget \
    && rm -rf /var/lib/apt/lists/*  # -- Free space up (about 40MB) --

# TODO Problematic installs:
apt-get -qq install \
    libusb-1.0-0-dbg \
    python-software-properties \

# Install Realsense 2.19.0
# ------------------------
cd /tmp 
git clone --depth 1 -b 'v2.19.0' https://github.com/IntelRealSense/librealsense.git
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
make -j$cpu_cores
make install
# Delete Realsense source
cd /
rm -rf /tmp/librealsense

# Install OpenCV 3.3.1
# ------------------------
cd /tmp
git clone --depth 1 --branch 3.3.1 https://github.com/opencv/opencv.git
git clone --depth 1 --branch 3.3.1 https://github.com/opencv/opencv_contrib.git
cd opencv_contrib
mv modules/dnn_modern/CMakeLists.txt \
   modules/dnn_modern/CMakeLists.txt.bak
cd ../opencv
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
make -j$cpu_cores
make install
# Delete OpenCV 3.3.1 source
cd /
rm -rf /tmp/opencv /tmp/opencv_contrib
