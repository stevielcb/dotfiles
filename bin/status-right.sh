#!/usr/bin/env zsh

TMUX_STATUS_BG_COLOR="#2b303a"
TMUX_TASK_COLOR_BG="#00b548"
TMUX_TASK_COLOR_FG="#000000"
TMUX_HOST_COLOR_BG="#006db5"
TMUX_HOST_COLOR_FG="#ffffff"

function ssh_user_online() {
  who | grep '([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+)' 2>&1 >/dev/null
}

if [[ -d ~/.task ]]; then
  STATUS_LINE="#[fg=$TMUX_TASK_COLOR_BG,bg=$TMUX_STATUS_BG_COLOR,nobold,nounderscore,noitalics]#[fg=$TMUX_TASK_COLOR_FG,bg=$TMUX_TASK_COLOR_BG]#{tasks_status}"
  STATUS_LINE+="#[fg=$TMUX_HOST_COLOR_BG,bg=$TMUX_TASK_COLOR_BG,nobold,nounderscore,noitalics]#[fg=$TMUX_HOST_COLOR_FG,bg=$TMUX_HOST_COLOR_BG] "
else
  STATUS_LINE+="#[fg=$TMUX_HOST_COLOR_BG,bg=$TMUX_STATUS_BG_COLOR,nobold,nounderscore,noitalics]#[fg=$TMUX_HOST_COLOR_FG,bg=$TMUX_HOST_COLOR_BG] "
fi

if ssh_user_online; then
  STATUS_LINE+='#H'
else
  STATUS_LINE+='#h'
fi

STATUS_LINE+=' #( ~/bin/os-icon.sh ) '


tmux set -g status-right "${STATUS_LINE}"
