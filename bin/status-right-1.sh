#!/usr/bin/env zsh

# This script sets a custom status line for tmux using zsh.
# 
# Variables:
# TMUX_STATUS_BG_COLOR: Background color for the status line.
# TMUX_TIME_COLOR_BG: Background color for the time section.
# TMUX_TIME_COLOR_FG: Foreground color for the time section.
# TMUX_TIME_FORMAT: Format for displaying the time.
# STATUS_LINE: The formatted status line string with colors and time format.
#
# The script sets the tmux environment variable 'status_right_1' to the custom status line.

# Powerline separators and the OS icon are private-use-area glyphs. If the shell
# running this script has no UTF-8 locale, tmux stores them as "_". run-shell
# inherits the server environment (which has LANG set), but a manual
# `source-file` from a bare shell does not.
case "${LC_ALL:-${LC_CTYPE:-${LANG:-}}}" in
  *[Uu][Tt][Ff]*) ;;
  *) export LC_ALL=en_US.UTF-8 ;;
esac

TMUX_STATUS_BG_COLOR="#2b303a"
TMUX_TIME_COLOR_BG="#565554"
TMUX_TIME_COLOR_FG="#ffffff"

TMUX_TIME_FORMAT="%a  %b %d  %r"

STATUS_LINE="#[fg=$TMUX_TIME_COLOR_BG,bg=$TMUX_STATUS_BG_COLOR,nobold,nounderscore,noitalics]#[fg=$TMUX_TIME_COLOR_FG,bg=$TMUX_TIME_COLOR_BG] $TMUX_TIME_FORMAT "

tmux set-environment -g status_right_1 "${STATUS_LINE}"
