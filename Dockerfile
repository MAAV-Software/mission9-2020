FROM ros:melodic

WORKDIR /

ADD scripts/setup-docker.sh /setup-docker.sh

RUN /setup-docker.sh