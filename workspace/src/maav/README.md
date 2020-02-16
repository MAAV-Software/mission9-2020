# MAAV ROS Source

## GPS control instruction

1. Run Docker and start tmux to open multiple terminals.
2. Type roscore in one terminal to start ROS.
3. Run the simulator (see sim readme)
4. Build our ros nodes (`catkin build` in workspace directory)
5. Run devel/lib/maav/gps_node and gps_input in terminals.

You should see the drone take off and be able to feed it GPS coordinates.