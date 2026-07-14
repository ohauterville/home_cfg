
# Start tmux session (args: session and up to 4 cmds)
[group('TMUX')]
tmux-send-cmds SESSION="default" CMD0="" CMD1="" CMD2="" CMD3="":
    @../../entrypoints/tmux.sh "{{SESSION}}" "{{CMD0}}" "{{CMD1}}" "{{CMD2}}" "{{CMD3}}"
#@"${ROS_WS_DIR}"/entrypoints/tmux.sh "{{SESSION}}" "{{CMD0}}" "{{CMD1}}" "{{CMD2}}" "{{CMD3}}"

# List running tmux server
[group('TMUX')]
tmux-list-servers:
    @ls /tmp/tmux-$(id -u)/

# Tmux attach
[group('TMUX')]
tmux-attach SESSION="":
    #!/bin/bash
    if [ -n "{{SESSION}}" ]; then
        tmux -L $HOST attach -t "{{SESSION}}"
    else
        tmux -L $HOST attach
    fi

# Kill tmux server (args: server)
tmux-kill-server SERVER="":
    #!/bin/bash
    if [ -n "{{SERVER}}" ]; then
        tmux -L {{SERVER}} kill-server
        rm /tmp/tmux-$(id -u)/{{SERVER}}
    else
        echo "Run again with which server you want to kill:"
        just tmux-list-servers
    fi

# Add a window to a running session (args: session window cmd)
# [group('tmux')]
# tmux-add-window SESSION NAME="" CMD="":
#     #!/bin/bash
#     if ! tmux has-session -t {{SESSION}} 2>/dev/null; then
#         echo "⚠️  Session '{{SESSION}}' introuvable. Sessions disponibles :"
#         tmux ls
#         exit 1
#     fi
#     if [ -n "{{CMD}}" ]; then
#         tmux new-window -t {{SESSION}} -n "{{NAME}}" "{{CMD}}"
#     else
#         tmux new-window -t {{SESSION}} -n "{{NAME}}"
#     fi

