#!/bin/bash

# Use an appropriate amount of CPU cores based on this system
cpu_cores=$(($(grep -c ^processor /proc/cpuinfo)-1))
cpu_cores=$((cpu_cores > 1 ? cpu_cores : 1))

# Place apt in non interactive mode
# TODO Is using export okay here?
export DEBIAN_FRONTEND=noninteractive

# Install Gazebo
echo "*** Installing Gazebo9"
apt-get -qq install protobuf-compiler > /dev/null
curl -sSL http://get.gazebosim.org | sh > /dev/null

# Ubuntu Config
echo "*** Remove modemmanager due to conflict issues"
apt-get -qq remove modemmanager

# Common dependencies
echo "*** Installing common dependencies"
apt-get -qq install \
    build-essential \
    genromfs \
    libopencv-dev \
    ninja-build \
    qtcreator \
    zip \
    > /dev/null

# Required python packages
echo "*** Installing python packages"
apt-get -qq install \
    python-argparse \
    python-dev \
    python-empy \
    python-numpy \
    python-pip \
    python-toml \
    python-yaml
    > /dev/null
python -m pip install --upgrade pip \
    > /dev/null
python -m pip install pandas jinja2 pyserial \
    > /dev/null

# optional python tools
python3 -m pip install pyulog
python3 -m pip install pyyaml

# Install FastRTPS 1.5.0 and FastCDR-1.0.7
fastrtps_dir=$HOME/eProsima_FastRTPS-1.5.0-Linux
echo "*** Installing FastRTPS to: $fastrtps_dir"
if [ -d "$fastrtps_dir" ]
then
    echo "*** FastRTPS already installed."
else
    pushd .
    cd ~
    wget -nv https://www.eprosima.com/index.php/component/ars/repository/eprosima-fast-dds/eprosima-fast-rtps-1-5-0/eprosima_fastrtps-1-5-0-linux-tar-gz -O eprosima_fastrtps-1-5-0-linux.tar.gz
    echo "*** Unpacking zips for FastRTPS"
    tar -xzf eprosima_fastrtps-1-5-0-linux.tar.gz eProsima_FastRTPS-1.5.0-Linux/
    tar -xzf eprosima_fastrtps-1-5-0-linux.tar.gz requiredcomponents
    tar -xzf requiredcomponents/eProsima_FastCDR-1.0.7-Linux.tar.gz
    echo "*** Installing FastCDR 1.0.7"
    cd eProsima_FastCDR-1.0.7-Linux
    ./configure --libdir=/usr/lib > /dev/null
    make -j$cpu_cores
    make install
    cd ..
    echo "*** Installing FastRTPS 1.5.0"
    cd eProsima_FastRTPS-1.5.0-Linux
    ./configure --libdir=/usr/lib > /dev/null
    make -j$cpu_cores
    make install
    cd ..
    echo "*** Removing FastRTPS build artifacts"
    rm -rf requiredcomponents eprosima_fastrtps-1-5-0-linux.tar.gz
    popd
fi

# Install some dependencies for QGroundControl
apt-get -qq install \
    libfuse-dev \
    libpulse-mainloop-glib0 \
    > /dev/null

# Download QGroundControl
if [ ! -f exe/QGroundControl.AppImage ]; then
	echo "*** Downloading QGroundControl"
	wget -nv https://s3-us-west-2.amazonaws.com/qgroundcontrol/builds/master/QGroundControl.AppImage -P /bin
	chmod a+x /bin/QGroundControl.AppImage
fi
