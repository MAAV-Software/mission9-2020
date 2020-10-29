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

RUN mkdir /workspace && touch /workspace/.catkin_workspace && \
    mkdir /workspace/src &&\
    cd /workspace/src &&\
    git clone https://github.com/PX4/avoidance &&\
    cd /workspace/src/avoidance &&\
    git checkout 00ef8b8f884bf715fbf61b5f8a8fb9adf21a1579
