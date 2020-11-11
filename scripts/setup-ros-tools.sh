#!/bin/bash

# Place apt in non interactive mode
# TODO Is using export okay here?
export DEBIAN_FRONTEND=noninteractive

# ROS Tools
apt-get -qq install \
    ros-melodic-rviz \
    ros-melodic-rqt \
    ros-melodic-rqt-common-plugins \
    > /dev/null
