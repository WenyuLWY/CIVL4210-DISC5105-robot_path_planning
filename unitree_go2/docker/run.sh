#!/bin/bash

source config.env

if docker container inspect "$CONTAINER_NAME" > /dev/null 2>&1; then
      echo "Container already exists."
      echo "Stopping and removing the existing container..."
      docker stop $CONTAINER_NAME
      docker rm $CONTAINER_NAME
fi

PKG_ROOT_DIR=$(dirname "$(dirname "$(readlink -f "$0")")")
MOUNT_ARGS=""

for path in "$PKG_ROOT_DIR"/src/*; do
      name=$(basename "$path")
      MOUNT_ARGS="$MOUNT_ARGS -v $path:/home/user/ros2_ws/src/$name"
done



if grep -qi microsoft /proc/version; then # Check if running in WSL
  docker run -it --rm --name $CONTAINER_NAME \
     --user user \
     --gpus all --device=/dev/dxg \
    -e DISPLAY=$DISPLAY \
    -e WAYLAND_DISPLAY=$WAYLAND_DISPLAY \
    -e PULSE_SERVER=$PULSE_SERVER \
    -e XDG_RUNTIME_DIR=/tmp/runtime-user \
    -e LD_LIBRARY_PATH=/usr/lib/wsl/lib \
    -v /mnt/wslg:/mnt/wslg \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /usr/lib/wsl:/usr/lib/wsl \
    $IMAGE_NAME bash
else # Running in ubuntu environment
  XAUTH="$(dirname "$(readlink -f "$0")")/.docker.$CONTAINER_NAME.xauth"

  rm -f "$XAUTH"
  touch "$XAUTH"
  xauth nlist "$DISPLAY" | sed -e 's/^..../ffff/' | xauth -f "$XAUTH" nmerge -
  chmod 644 "$XAUTH"

  docker run -it --rm --name $CONTAINER_NAME \
      --user user \
      --gpus all -e NVIDIA_VISIBLE_DEVICES=all -e NVIDIA_DRIVER_CAPABILITIES=all \
      --privileged --net=host -v /dev:/dev \
      -e XDG_RUNTIME_DIR=/tmp/runtime-user \
      -e DISPLAY=$DISPLAY -e TERM -e QT_X11_NO_MITSHM=1 \
      -e XAUTHORITY=/home/user/.docker.$CONTAINER_NAME.xauth \
      -v $XAUTH:/home/user/.docker.$CONTAINER_NAME.xauth \
      -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
      -v /etc/localtime:/etc/localtime:ro \
      $MOUNT_ARGS \
      $IMAGE_NAME bash
fi

