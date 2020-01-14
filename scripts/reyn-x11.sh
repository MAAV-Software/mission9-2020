#!/bin/bash

# Run this on reyn to properly configure docker image for hardware accelerated openGL X11 forwarded apps
apt-get purge nvidia*
add-apt-repository -y ppa:graphics-drivers
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -yq nvidia-driver-415