# Main zshrc loader
# This file sources modular configuration files and OS-specific overrides

# Ensure errors don't cause shell to exit during config loading
# (Individual commands should handle their own errors)
set +e

# Source modular configuration files
# Use error handling to prevent shell exit if a config file has errors
if [[ -d ~/.zshrc.d ]]; then
  for config_file in ~/.zshrc.d/*.zsh(N); do
    source "${config_file}" 2>/dev/null || true
  done
fi

# Oh My Zsh configuration
export ZSH=~/.oh-my-zsh

ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

# Powerlevel10k theme (MUST be set before sourcing Oh-My-Zsh)
ZSH_THEME="powerlevel10k/powerlevel10k"

# Zsh plugins (Oh-My-Zsh)
ZSH_PLUGINS=(
  ansible
  aws
  colored-man-pages
  common-aliases
  copybuffer
  copyfile
  copypath
  dircycle
  docker
  encode64
  extract
  F-Sy-H
  git
  gitignore
  golang
  httpie
  iterm2
  jsontools
  ng
  node
  npm
  pip
  poetry
  python
  redis-cli
  screen
  sudo
  tmux
  urltools
  vagrant
  vscode
  web-search
  z
  zsh-autopair
  zsh-autosuggestions
)

# Source OS-specific runtime configuration (before Oh-My-Zsh).
# This comes after ZSH_PLUGINS is defined above because the OS files extend it
# with ZSH_PLUGINS+=(...); sourcing earlier would let the base array overwrite them.
# Use error handling to prevent shell exit if OS config has errors
if [[ -f ~/.zshrc.$(uname) ]]; then
  source ~/.zshrc.$(uname) 2>/dev/null || true
fi

# Convert array to zsh array format
set -A plugins ${(v)ZSH_PLUGINS}

# Source Oh-My-Zsh (only if it exists - installed by bootstrap)
# This will load the theme specified in ZSH_THEME
# Use error handling to prevent shell exit if Oh-My-Zsh has issues
if [[ -f "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh" 2>/dev/null || {
    echo "Warning: Failed to load Oh-My-Zsh. Run 'dotfiles bootstrap' to install." >&2
  }
fi

# Load fzf key-bindings and completion AFTER Oh-My-Zsh so Ctrl-R (and other fzf bindings)
# are not overwritten by OMZ's lib/key-bindings.zsh (history-incremental-search-backward).
# FZF_DEFAULT_OPTS and FZF_DEFAULT_COMMAND are set in 90-integrations.zsh.
if [[ -d /usr/share/fzf ]]; then
  [[ -f /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh
  [[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
elif [[ -f ~/.fzf.zsh ]]; then
  source ~/.fzf.zsh
elif command -v brew >/dev/null 2>&1; then
  fzf_after_prefix=$(brew --prefix fzf 2>/dev/null)
  if [[ -n "${fzf_after_prefix}" ]]; then
    [[ -f "${fzf_after_prefix}/shell/completion.zsh" ]] && source "${fzf_after_prefix}/shell/completion.zsh"
    [[ -f "${fzf_after_prefix}/shell/key-bindings.zsh" ]] && source "${fzf_after_prefix}/shell/key-bindings.zsh"
  fi
fi
