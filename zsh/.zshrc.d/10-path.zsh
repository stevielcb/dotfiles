# PATH configuration
# Uses typeset -U to deduplicate paths automatically

# Ensure user bin directories exist (created by bootstrap, but safe to check)
[[ -d ~/bin ]] || mkdir -p ~/bin
[[ -d ~/go/bin ]] || mkdir -p ~/go/bin
[[ -d ~/.local/bin ]] || mkdir -p ~/.local/bin
[[ -d ~/.cargo/bin ]] || mkdir -p ~/.cargo/bin

# Use typeset -U to make path array unique (no duplicates)
typeset -U path

# Add paths (order matters - earlier paths take precedence)
path=(
  ~/bin
  ~/go/bin
  ~/.local/bin
  ~/.cargo/bin
  /opt/homebrew/bin
  /opt/homebrew/sbin
  /usr/local/bin
  ~/.iterm2
  /usr/local/sbin
  $path
)

# Export PATH (though path array is automatically exported)
export PATH
