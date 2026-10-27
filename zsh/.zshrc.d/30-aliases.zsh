# Aliases

# File viewing/editing
alias b="bat -p"
alias c="b"

# Directory listing (using eza)
alias du="ncdu -rex --color dark"
alias ldir="eza -lahg --git --time-style=long-iso --only-dirs --icons"
alias l="eza -la --git --time-style=long-iso --group-directories-first --icons"
alias la="eza -lahg --git --time-style=long-iso --group-directories-first --icons"
alias ll="eza -l --git --time-style=long-iso --group-directories-first --icons"
alias lsize="l -ssize"

# LastPass integration
alias lp="lpass show -c --password \$(lpass ls | fzf | awk '{print \$(NF)}' | sed 's/\]//g')"
alias lpn="lpass show -c --notes \$(lpass ls | fzf | awk '{print \$(NF)}' | sed 's/\]//g')"
alias lpu="lpass show -c --username \$(lpass ls | fzf | awk '{print \$(NF)}' | sed 's/\]//g')"

# Search and tools
alias f="fzf --preview 'bat -p --color=always {}'"
alias h="nocorrect howdoi"
alias http="http -F --style paraiso-dark"
alias m="motd-client"
alias ping="prettyping --nolegend"
alias rg="rg -p"
alias task="nocorrect task"
alias top="htop"

# Tmux
alias td="tmux detach"
