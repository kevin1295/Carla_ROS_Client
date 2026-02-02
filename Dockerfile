FROM osrf/ros:foxy-desktop

LABEL maintainer="kevin1295@qq.com"

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV SHELL=/bin/bash
ENV ROSDISTRO_INDEX_URL=file:///etc/ros/rosdep/index-v4.yaml

RUN mkdir -p /root/offline-resources

WORKDIR /root/offline-resources
RUN apt-get update \
    && apt install -y --no-install-recommends \
        python3-pip python3-dev python3-venv \
        ros-foxy-ackermann-msgs ros-foxy-derived-object-msgs \
    && apt clean && rm -rf /var/lib/apt/lists/*

COPY offline-resources/*.whl /root/offline-resources/
RUN python3 -m pip install --upgrade pip \
    && python3 -m pip install --no-index --find-links=/root/offline-resources/ *.whl \
    && rm -rf /root/.cache/pip

RUN mkdir -p /root/carla-ros-bridge/src
COPY offline-resources/ros-bridge /root/carla-ros-bridge/src/ros-bridge
COPY offline-resources/rosdep/ /etc/ros/rosdep/
COPY offline-resources/rosdep/ /root/.ros/rosdep/

WORKDIR /root/carla-ros-bridge
RUN bash -c " \
    set -e; \
    . /opt/ros/foxy/setup.bash; \
    xargs apt install -y --no-download < /root/.ros/rosdep/rosdep_install_list.txt; \
    colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release \
                --cmake-args -DCMAKE_INSTALL_PREFIX=/root/carla-ros-bridge/install \
                --no-warn-unused-cli; \
    rm -rf build log; \
    apt clean && rm -rf /var/lib/apt/lists/* \
"

RUN echo "# Load ROS Foxy environment" >> ~/.bashrc \
    && echo "source /opt/ros/foxy/setup.bash" >> ~/.bashrc \
    && echo "# Load Carla ROS Bridge environment" >> ~/.bashrc \
    && echo "source /root/carla-ros-bridge/install/setup.bash" >> ~/.bashrc \
    && echo "export ROS_WORKSPACE=/root/carla-ros-bridge" >> ~/.bashrc

ENV DEBIAN_FRONTEND=dialog

WORKDIR /root

CMD ["/bin/bash"]