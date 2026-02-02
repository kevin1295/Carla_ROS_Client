# CARLA_ROS_Client

## Discription

A docker image based on osrf/ros:foxy-desktop, and can connect to CARLA server (carlasim/carla) directly.

Image is currently available at docker hub (goldfish1295/carla_ros_client:0.9.13-foxy).

## Plan

- [ ] Check if there is something I forgot to add during my other projects.
- [ ] Add support for other versions of ROS and carla

## Usage

You do not need to download this repository, just pull the image from docker hub.  
After you have installed docker and nvidia container toolkit, run

```bash
docker pull carlasim/carla:0.9.13
docker run \
    --runtime=nvidia \
    --net=host \
    --user=$(id -u):$(id -g) \
    --env=DISPLAY=$DISPLAY \
    --env=NVIDIA_VISIBLE_DEVICES=all \
    --env=NVIDIA_DRIVER_CAPABILITIES=all \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --name carla_server \
    carlasim/carla:0.9.13 bash CarlaUE4.sh -nosound
```

This will start carla server with a window where you can see a carla world.  
Or you can run commands below to start carla server in headless mode.

```bash
docker run \
    --runtime=nvidia \
    --net=host \
    --env=NVIDIA_VISIBLE_DEVICES=all \
    --env=NVIDIA_DRIVER_CAPABILITIES=all \
    --name carla_server_headless \
    carlasim/carla:0.9.13 bash CarlaUE4.sh -RenderOffScreen -nosound
```

Then create you ros client container with command below.

```bash
docker pull goldfish1295/carla_ros_client:0.9.13-foxy
docker run \
    --runtime=nvidia \
    --net=host \
    --device=/dev/snd \
    --device=/dev/dri:/dev/dri \
    --env=DISPLAY=$DISPLAY \
    --env=NVIDIA_VISIBLE_DEVICES=all \
    --env=NVIDIA_DRIVER_CAPABILITIES=all \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --name ros_client \
    -it \
    goldfish1295/carla_ros_client:0.9.13-foxy
```

This command add sound and x11 forwarding to ros client container, if you do not need them, you can remove those options.
