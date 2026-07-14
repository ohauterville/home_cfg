# colcon build all pkgs
[group('Build')]
cb:
	@cd ros2_ws 
	@colcon build

# colcon build symlink all pkgs
[group('Build')]
cbs:
	@cd ros2_ws 
	@colcon build --symlink-install

# colcon build some pkg
[group('Build')]
cbp *pkg:
	@cd ros2_ws 
	@colcon build --packages-select {{pkg}}

# colcon build symlink and some pkg
[group('Build')]
cbsp *pkg:
	@cd ros2_ws 
	@colcon build --symlink-install --packages-select {{pkg}}

# Delete build install and log for a clean rebuild
[group('Build')]
clean:
    @cd ros2_ws && rm -rf build install log

# Source dev_ws
[group('Build')]
[group('ROS')]
source:
	@cd ros2_ws
	@source install/local_setup.sh

# Scan ip on a network
[group('Network')]
ip_scan IP="192.168.100.1":
	@nmap -sn {{IP}}/24 

# Get my IP and MAC, needs nmcli client enable
[group('Network')]
ip_mac:
	@nmcli -f GENERAL.DEVICE,GENERAL.HWADDR,IP4.ADDRESS device show

[group('info')]
version:
    @echo "Base commit:  $BASE_BUILD_COMMIT"
    @echo "App commit:   $APP_BUILD_COMMIT"
    @echo "Base build date:  $BASE_BUILD_DATE"
    @echo "App build date:   $APP_BUILD_DATE"
