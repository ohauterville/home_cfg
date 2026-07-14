# Source all ros workspaces
[group('Build')]
[group('ROS')]
source_ros:
	@"${ROS_WS_DIR}"/entrypoints/ros.sh

# Start zenoh router
[group('ROS')]
[group('RMW')]
zenoh ROUTER="BASE_STATION":
	#!/bin/bash
	if [ $RMW_IMPLEMENTATION = "rmw_zenoh_cpp" ]; then
		export ZENOH_ROUTER_CONFIG_URI="${ROS_WS_DIR}"/config/zenoh/{{ROUTER}}/RMW_ZENOH_ROUTER_CONFIG.json5
		ros2 run rmw_zenoh_cpp rmw_zenohd
	else
		echo "Current RMW_IMPLEMENTATION: $RMW_IMPLEMENTATION" 
	fi

# Start rosboard
[group('ROS')]
[group('Viz')]
rosboard:
	@. $PYTHON_ROSBOARD_VENV/bin/activate 
	@echo "\n\n\nhttp://localhost:8888"  
	@$ROS_WS_DIR/src/rosboard/run	

# Start plotjuggler
[group('Viz')]
[group('ROS')]
plotjuggler:
	@ros2 run plotjuggler plotjuggler

# Start a GUI to manage lifecycle nodes
[group('ROS')]
lifecycle_manager:
	@"${ROS_WS_DIR}/scripts/lifecycle_node_manager/lifecycle_manager.py"

# Find available bag files (mcap, db3) from current dir 
[group('ROS')]
bag-file:
    @find . -type f \( -name "*.mcap" -o -name "*.db3" \) | sort

# Find available bags from current dir
[group('ROS')]
bag-dir:
	@find . -name "metadata.yaml" -exec dirname {} \; | sed 's|^\./||' | sort

# Play a rosbag (do: just bag-dir then just bag-play {BAG_DIR})
[group('ROS')]
bag-play:
    @ros2 bag play

# Record a rosbag with all topics
[group('ROS')]
record *ARG: 
    @ros2 bag record -a ARG