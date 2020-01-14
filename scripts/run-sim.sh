cd /PX4Firmware
source /opt/ros/melodic/setup.bash
DONT_RUN=1 make px4_sitl_default gazebo
source /mission9/workspace/devel/setup.bash
source Tools/setup_gazebo.bash $(pwd) $(pwd)/build/px4_sitl_default
export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:$(pwd)
export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:$(pwd)/Tools/sitl_gazebo
export GAZEBO_MODEL_PATH=${GAZEBO_MODEL_PATH}:/mission9/workspace/src/avoidance/sim/models

cd /mission9/workspace
roslaunch px4 mavros_posix_sitl.launch