#!/usr/bin/env zsh

function ssh_user_online() {
  who | grep '([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+)' 2>&1 >/dev/null
}

STATUS_LINE='#[fg=#4800b5,bg=#4800b5,nobold,nounderscore,noitalics]#[fg=colour121,bg=#4800b5] %a  %b %d  %r #[fg=#6e61ff,bg=#4800b5,nobold,nounderscore,noitalics]#[fg=#ffffff,bg=#6e61ff] '

if ssh_user_online; then
  STATUS_LINE+='#H'
else
  STATUS_LINE+='#h'
fi

if [ -d ~/.task ]; then
  STATUS_LINE+='#[fg=#85ff9f,bg=#6e61ff,nobold,nounderscore,noitalics]#[fg=black,bg=#91ff93]#{tasks_status}'
fi

tmux set -g status-right "${STATUS_LINE}"
