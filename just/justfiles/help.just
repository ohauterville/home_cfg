# HELP with apptainer
[group('HELP')]
HELP_apptainer:
	@echo "⚠️ These commands should be run from inside an apptainer but from a machine. There are just a reminder."
	@echo "Run: apptainer instance run --bind ./home:/home <SIF_FILE>"
	@echo "List instances: apptainer instance list"
	@echo "Start instance: apptainer instance start <SIF_FILE> <NAME>"
	@echo "Stop instance: apptainer instance stop <NAME>"
	@echo "See instance logs in ~/.apptainer/instances/logs"

# HELP with tmux
[group('HELP')]
[group('TMUX')]
HELP_tmux:
	@echo "List tmux sessions: tmux ls"
	@echo "Attach to last seesion: tmux a"
	@echo "Attach to targetted session: tmux a -t <SESSION>"
	@echo "Detach from session: Ctrl+b and d"
	@echo "Zoom: Ctrl+b and z"
	@echo "Change pane: Ctrl+b and ARROWS"
	@echo "Scroll: Ctrl+b and [   (quit with q, ctrl+c or Esc)"
	@echo "Split terminal vertically: Ctrl+b and %"
	@echo 'Split terminal horizontally: Ctrl+b and " '
	@echo "Turning a pane into a window: Ctrl+b and !"
	@echo "List windows: Ctrl+b and W"
	@echo "List sessions: Ctrl+b and S"
	@echo "Kill session: Ctrl+b and & then y"
	@echo "Cheatsheet: https://phoenixnap.com/kb/wp-content/uploads/2024/09/tmux-commands-cheat-sheet.pdf"

# Use DDS ROS middleware
[group('HELP')]
[group('RMW')]
HELP_RMW:
	@echo "Change RMW to DDS: export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp"
	@echo "Change RMW to Zenoh: export RMW_IMPLEMENTATION=rmw_zenoh_cpp"