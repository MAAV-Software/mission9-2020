#!/bin/bash

# Use an appropriate amount of CPU cores based on this system
cpu_cores=$(($(grep -c ^processor /proc/cpuinfo)-1))
cpu_cores=$((cpu_cores > 1 ? cpu_cores : 1))

# Install Gazebo
echo "Installing Gazebo9"
sleep 3

apt-get -qq install protobuf-compiler
curl -sSL http://get.gazebosim.org | sh

# Ubuntu Config
echo "We must first remove modemmanager"
apt-get -qq remove modemmanager

# Common dependencies
echo "Installing common dependencies"
apt-get -qq install \
    git zip qtcreator cmake build-essential genromfs ninja-build libopencv-dev

# Required python packages
apt-get -qq install \
    python-argparse python-empy python-toml python-numpy python-dev \
    python-pip python-yaml
python -m pip install --upgrade pip
python -m pip install pandas jinja2 pyserial

# optional python tools
python3 -m pip install pyulog
python3 -m pip install pyyaml

# Install FastRTPS 1.5.0 and FastCDR-1.0.7
fastrtps_dir=$HOME/eProsima_FastRTPS-1.5.0-Linux
echo "Installing FastRTPS to: $fastrtps_dir"
if [ -d "$fastrtps_dir" ]
then
    echo " FastRTPS already installed."
else
    pushd .
    cd ~
    wget http://www.eprosima.com/index.php/component/ars/repository/eprosima-fast-rtps/eprosima-fast-rtps-1-5-0/eprosima_fastrtps-1-5-0-linux-tar-gz -O eprosima_fastrtps-1-5-0-linux.tar.gz
    tar -xzf eprosima_fastrtps-1-5-0-linux.tar.gz eProsima_FastRTPS-1.5.0-Linux/
    tar -xzf eprosima_fastrtps-1-5-0-linux.tar.gz requiredcomponents
    tar -xzf requiredcomponents/eProsima_FastCDR-1.0.7-Linux.tar.gz
    cd eProsima_FastCDR-1.0.7-Linux; ./configure --libdir=/usr/lib; make -j$cpu_cores; make install
    cd ..
    cd eProsima_FastRTPS-1.5.0-Linux; ./configure --libdir=/usr/lib; make -j$cpu_cores; make install
    cd ..
    rm -rf requiredcomponents eprosima_fastrtps-1-5-0-linux.tar.gz
    popd
fi

# Install some dependencies for QGroundControl
apt-get -qq install libfuse-dev libpulse-mainloop-glib0

# Download QGroundControl
if [ ! -f exe/QGroundControl.AppImage ]; then
	echo "Downloading QGroundControl"
	wget https://s3-us-west-2.amazonaws.com/qgroundcontrol/builds/master/QGroundControl.AppImage -P /bin
	chmod a+x /bin/QGroundControl.AppImage
fi
