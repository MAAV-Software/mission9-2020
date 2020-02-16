# Simulator Instructions

To run the simulation (server and client), run `run-sim.sh`. If you have a machine capable of X-forwarding, this is the only thing you have to do in order to see the simulation on your computer. But unless you are running a fairly beefy Linux machine, this will likely not be a good option. 

To run just the client, run `run-sim-client.sh`. If the sim is running in Docker, you should automatically connect to it by running this script. You must install Gazebo on your machine for this to work. You may also need to clone and build the [PX4 Firmware](https://github.com/PX4/Firmware) to see the drone model properly until we switch to our own .sdf model.

To use QGroundControl, install it on your local machine and add a UDP connection with port `14557` and target host as localhost. This can be done by hitting the purple Q button in the top left, selecting Comm Links, and Add. Run the sim in Docker, and you will be able to connect to the drone from host. More info can be found [here](https://dev.px4.io/v1.9.0/en/test_and_ci/docker.html). QGroundControl cannot be used within Docker and X-forwarded because you cannot run QGroundControl as root.
