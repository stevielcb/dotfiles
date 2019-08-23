#!/usr/bin/env zsh

TMUX_STATUS_BG_COLOR="#2b303a"
TMUX_TIME_COLOR_BG="#565554"
TMUX_TIME_COLOR_FG="#ffffff"

TMUX_TIME_FORMAT="%a  %b %d  %r"

STATUS_LINE="#[fg=$TMUX_TIME_COLOR_BG,bg=$TMUX_STATUS_BG_COLOR,nobold,nounderscore,noitalics]#[fg=$TMUX_TIME_COLOR_FG,bg=$TMUX_TIME_COLOR_BG] $TMUX_TIME_FORMAT "

tmux set-environment -g status_right_1 "${STATUS_LINE}"
