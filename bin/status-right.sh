#!/usr/bin/env zsh

# This script sets the right status line in tmux with various information.
# 
# Variables:
# TMUX_STATUS_BG_COLOR - Background color for the status line.
# TMUX_TASK_COLOR_BG - Background color for the task status section.
# TMUX_TASK_COLOR_FG - Foreground color for the task status section.
# TMUX_HOST_COLOR_BG - Background color for the host section.
# TMUX_HOST_COLOR_FG - Foreground color for the host section.
#
# Functions:
# ssh_user_online - Checks if there are any users connected via SSH.
#
# The script checks if the ~/.task directory exists. If it does, it adds a task status section to the status line.
# It then adds a host section to the status line.
# If there are users connected via SSH, it adds the full hostname (#H) to the status line.
# Otherwise, it adds the short hostname (#h).
# Finally, it adds an OS icon to the status line by calling the ~/bin/os-icon.sh script.
#
# The constructed status line is then set as the tmux status-right option.

# Powerline separators and the OS icon are private-use-area glyphs. If the shell
# running this script has no UTF-8 locale, tmux stores them as "_". run-shell
# inherits the server environment (which has LANG set), but a manual
# `source-file` from a bare shell does not.
case "${LC_ALL:-${LC_CTYPE:-${LANG:-}}}" in
  *[Uu][Tt][Ff]*) ;;
  *) export LC_ALL=en_US.UTF-8 ;;
esac

TMUX_STATUS_BG_COLOR="#2b303a"
TMUX_TASK_COLOR_BG="#00b548"
TMUX_TASK_COLOR_FG="#000000"
TMUX_HOST_COLOR_BG="#006db5"
TMUX_HOST_COLOR_FG="#ffffff"

function ssh_user_online() {
  who 2>/dev/null | grep -q '([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+)' 2>/dev/null
}

if [[ -d ~/.task ]]; then
  STATUS_LINE="#[fg=$TMUX_TASK_COLOR_BG,bg=$TMUX_STATUS_BG_COLOR,nobold,nounderscore,noitalics]#[fg=$TMUX_TASK_COLOR_FG,bg=$TMUX_TASK_COLOR_BG]#{tasks_status}"
  STATUS_LINE+="#[fg=$TMUX_HOST_COLOR_BG,bg=$TMUX_TASK_COLOR_BG,nobold,nounderscore,noitalics]#[fg=$TMUX_HOST_COLOR_FG,bg=$TMUX_HOST_COLOR_BG] "
else
  STATUS_LINE="#[fg=$TMUX_HOST_COLOR_BG,bg=$TMUX_STATUS_BG_COLOR,nobold,nounderscore,noitalics]#[fg=$TMUX_HOST_COLOR_FG,bg=$TMUX_HOST_COLOR_BG] "
fi

if ssh_user_online; then
  STATUS_LINE+='#H'
else
  STATUS_LINE+='#h'
fi

# os-icon.sh is a static uname lookup, so resolve it once here instead of
# leaving a #() in the format for tmux to fork every status-interval.
OS_ICON="$(~/bin/os-icon.sh 2>/dev/null)"
STATUS_LINE+=" ${OS_ICON} "


tmux set -g status-right "${STATUS_LINE}"
