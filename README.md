1. ROS1: scout - ros nav stack
roslaunch robot_simulation simulation1.launch

roslaunch robot_simulation localization1.launch

roslaunch robot_simulation planning1.launch

2. ROS1: scout - cmu aede
roslaunch robot_simulation simulation2.launch

roslaunch robot_simulation localization2.launch

roslaunch robot_simulation planning2.launch

3. ROS2: unitree go2 - cmu aede
ros2 launch robot_simulation simulation.launch.py

ros2 launch robot_simulation localization.launch.py

ros2 launch robot_simulation planning.launch.py
