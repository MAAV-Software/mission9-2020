FROM FROM osrf/ros:melodic-desktop-full

WORKDIR /

ADD scripts/setup-docker.sh /setup-docker.sh
ADD scripts/setup-sim.sh /setup-sim.sh

RUN /setup-docker.sh
RUN /setup-sim.sh
