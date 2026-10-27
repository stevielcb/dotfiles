# Integration with external tools (fzf, tmux, iTerm2, etc.)

# fzf configuration (key-bindings and completion are loaded after Oh-My-Zsh in .zshrc
# so Ctrl-R is not overwritten by OMZ's key-bindings.zsh)
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(${VISUAL} {})+abort'"
export FZF_DEFAULT_COMMAND="rg --hidden --files --smart-case --glob '!.git/*' 2>/dev/null"

# iTerm2 shell integration (only if file exists - installed by bootstrap)
# Use error handling to prevent shell exit if integration has issues
if [[ -f ~/.iterm2_shell_integration.zsh ]]; then
  source ~/.iterm2_shell_integration.zsh 2>/dev/null || true
fi

# Tmux autostart configuration (must be set before Oh-My-Zsh loads)
# Only configure for interactive shells, non-root, and not in vscode
if [[ -o interactive ]] && (( EUID != 0 )) && [[ "${TERM_PROGRAM:-}" != "vscode" ]]; then
  export ZSH_TMUX_AUTOSTART=true
  # CRITICAL: Set AUTOQUIT to false so shell stays open if tmux fails/exits
  # This prevents the window from closing when tmux encounters errors
  export ZSH_TMUX_AUTOQUIT=false
  export ZSH_TMUX_AUTOCONNECT=true
  export ZSH_TMUX_DEFAULT_SESSION_NAME="main"
  export ZSH_TMUX_AUTONAME_SESSION=false
fi

# Disable correction for tmux (set after Oh-My-Zsh loads and creates the alias)
# This prevents zsh from trying to "correct" tmux to .tmux
if (( $+aliases[tmux] )); then
  # Wrap the existing alias with nocorrect (top-level: do not use local)
  tmux_alias="${aliases[tmux]}"
  unalias tmux
  alias tmux="nocorrect $tmux_alias"
fi

# MOTD: show the banner under vscode, and start the server when it isn't
# already running. Both branches need to know whether the server is up, so
# check once - pgrep is the most expensive call in this file.
if [[ "${TERM_PROGRAM:-}" == "vscode" ]] || [[ -z "${SSH_CLIENT:-}" ]]; then
  if pgrep motd-server >/dev/null 2>&1; then
    [[ "${TERM_PROGRAM:-}" == "vscode" ]] && { motd-client 2>/dev/null || true }
  elif [[ -z "${SSH_CLIENT:-}" ]] && command -v motd-server >/dev/null 2>&1; then
    motd-server &! 2>/dev/null || true
  fi
fi

# Pipenv completion (if available)
# Note: This is wrapped in error handling to prevent shell exit on errors
if command -v pipenv >/dev/null 2>&1; then
  # Define completion function
  # Note: CURRENT and words are only available during actual completion, not at startup
  _pipenv() {
    # Check if we're in a completion context
    local current_val="${CURRENT:-0}"
    if (( current_val > 0 )) && [[ -n "${words:-}" ]]; then
      eval "$(env COMMANDLINE="${words[1,current_val]}" _PIPENV_COMPLETE=complete-zsh pipenv)" 2>/dev/null || true
    fi
  }
  # Only register completion if not already registered
  # Use explicit error handling to prevent shell exit
  {
    if [[ "$(basename -- ${(%):-%x})" != "_pipenv" ]]; then
      compdef _pipenv pipenv 2>/dev/null || true
    fi
  } || true
fi
