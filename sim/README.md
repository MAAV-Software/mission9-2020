# Simulator Instructions

To run the simulation (server and client), run `run-sim.sh`.

To run just the client, run `run-sim-client.sh`.

To use QGroundControl, install it on your local machine and add a UDP connection with port `14557` and target host as localhost. This can be done by hitting the purple Q button in the top left, selecting Comm Links, and Add. Run the sim in Docker, and you will be able to connect to the drone from host. More info can be found [here](https://dev.px4.io/v1.9.0/en/test_and_ci/docker.html). QGroundControl cannot be used within Docker and X-forwarded because you cannot run QGroundControl as root.
