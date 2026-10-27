FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

# 第一阶段：添加 ROS 2 源 + 安装所有包，合并为一个 RUN 层
RUN apt-get update && apt-get install -y \
        lsb-release curl wget ca-certificates git gnupg gdb \
        software-properties-common \
    && add-apt-repository universe \
    && curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key \
        -o /usr/share/keyrings/ros-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" \
        > /etc/apt/sources.list.d/ros2.list \
    && apt-get update && apt-get install -y \
        ros-humble-desktop \
        python3-argcomplete \
        ros-dev-tools \
        xvfb \
        x11vnc \
        novnc \
        websockify \
        xfce4 \
        xfce4-terminal \
        dbus-x11 \
        x11-utils \
        mesa-utils \
        libgl1-mesa-dri \
        python-is-python3 \
        python3-pip \
    && rm -rf /var/lib/apt/lists/*