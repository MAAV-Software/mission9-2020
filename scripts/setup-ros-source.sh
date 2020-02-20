source /opt/ros/melodic/setup.bash
source /mission9/workspace/devel/setup.bash || echo "Try running catkin_make all in /workspace"

# Source gazebo setup.sh
source /usr/share/gazebo/setup.sh

# Set the plugin path so Gazebo finds our model and sim
export GAZEBO_PLUGIN_PATH=${GAZEBO_PLUGIN_PATH}:/px4_sitl/sitl_gazebo/build
# Set the model path so Gazebo finds the airframes
export GAZEBO_MODEL_PATH=${GAZEBO_MODEL_PATH}:/px4_sitl/sitl_gazebo/models
# Disable online model lookup since this is quite experimental and unstable
export GAZEBO_MODEL_DATABASE_URI=""

# Set path to sitl_gazebo repository
export SITL_GAZEBO_PATH=/px4_sitl/sitl_gazebo

# build catkin workspace
cd /workspace
source /workspace/devel/setup.bash
source /opt/ros/melodic/setup.bash
catkin build