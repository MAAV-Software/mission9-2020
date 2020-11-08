FROM ros:melodic

WORKDIR /

ADD scripts/setup-docker.sh /setup-docker.sh
RUN /setup-docker.sh

ADD scripts/setup-sim.sh /setup-sim.sh
RUN /setup-sim.sh

ADD scripts/setup-px4.sh /setup-px4.sh
RUN /setup-px4.sh

ADD scripts/setup-ros-tools.sh /setup-ros-tools.sh
RUN /setup-ros-tools.sh

ADD scripts/setup-catkin-ws.sh /setup-catkin-ws.sh
RUN /setup-catkin-ws.sh
