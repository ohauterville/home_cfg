#Display all this file
alias aliases="grep -v '^#' ~/.bash_aliases | grep -v '^$'"
#CD
alias ws="cd ~/ws/gitlab_xlim/remix_ws"
alias wspro="cd ~/ws/gitlab_xlim"
alias wsper="cd ~/ws/github_perso"
#Apptainer
alias appr="apptainer run --nv --bind ./home:/home/apptainer"
alias appstart="apptainer instance start --bind ./home:/home/apptainer"
alias appstop="apptainer instance stop"
#terminator tmux
alias ttmux="tmux new-session -A -s main"
