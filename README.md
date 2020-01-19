# MAAV - IARC Mission 9
MAAV code for IARC Mission 9

## Setup
You can build and run this code on Ubuntu 18.04. The docker image [here](https://drive.google.com/open?id=1YE0MNjpv4ig2OeFO3EhkaceaZugoHSeE) contains all the necessary dependencies. It has Ubuntu 18.04 with ROS melodic alongside other dependencies necessary for building and running MAAV's software solution for IARC mission 9. Note, you will need a umich email to download the image. You can also build the image yourself (which takes a while) using the following command:

**NOTE:** Users running Docker on Windows will need to convert the script files from dos to unix. Before following the steps below, run the *windows_fix* script:
1. `cd scripts/` to enter scripts folder
2. `./windows_fix.sh` to run fix script
3. `cd ..` to return to mission9 folder before running docker build

```bash
docker build -t mission9 . # Don't forget the dot (.) at the end
```

The image can be loaded using 

```bash
docker load -i mission9.img
```

You can spin up a container with the image and run a terminal by running the following command from a directory containing the `docker-compose.yml` file in this repo.

```bash
docker-compose run --rm maav
```

This command will mount this repo as a volume in your container. You will have any code that you place here in your container. Use this method to build and run your code.

```bash
docker-compose run --rm maav # Spin up docker container
cd mission9 # Enter project directory
mkdir -p build # Make a build directory if it is not already there
cd build # Enter build directory
cmake .. # Generate Makefiles
make -j7 # Build using a maximum of 7 jobs
../bin/my_app # Run an app that was just built
```
