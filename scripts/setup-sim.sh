#!/bin/bash

# Install Gazebo
echo "Installing Gazebo9"
sleep 3

sudo apt install protobuf-compiler -y
curl -sSL http://get.gazebosim.org | sh

# Install PX4 firmware
echo "Installing PX4 firmware"
git clone https://github.com/PX4/Firmware.git PX4Firmware
# git clone --single-branch --branch v1.8.2 https://github.com/PX4/Firmware/ PX4Firmware
cd /PX4Firmware
git submodule update --init --recursive

# Ubuntu Config
echo "We must first remove modemmanager"
apt-get remove modemmanager -y

# Common dependencies
echo "Installing common dependencies"
apt-get install git zip qtcreator cmake build-essential genromfs ninja-build libopencv-dev -y

# Required python packages
apt-get install python-argparse python-empy python-toml python-numpy python-dev python-pip python-yaml -y
python -m pip install --upgrade pip
python -m pip install pandas jinja2 pyserial

# optional python tools
python -m pip install pyulog
python -m pip install pyyaml

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
    cpucores=$(( $(lscpu | grep Core.*per.*socket | awk -F: '{print $2}') * $(lscpu | grep Socket\(s\) | awk -F: '{print $2}') ))
    cd eProsima_FastCDR-1.0.7-Linux; ./configure --libdir=/usr/lib; make -j$cpucores; make install
    cd ..
    cd eProsima_FastRTPS-1.5.0-Linux; ./configure --libdir=/usr/lib; make -j$cpucores; make install
    cd ..
    rm -rf requiredcomponents eprosima_fastrtps-1-5-0-linux.tar.gz
    popd
fi


# Download QGroundControl
if [ ! -f exe/QGroundControl.AppImage ]; then
	echo "Downloading QGroundControl"
	wget https://s3-us-west-2.amazonaws.com/qgroundcontrol/builds/master/QGroundControl.AppImage -P /bin
	chmod a+x /bin/QGroundControl.AppImage
fi


