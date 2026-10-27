# Zsh options and settings
# This file configures zsh behavior, history, and completion

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY          # Share history between sessions
setopt HIST_IGNORE_DUPS       # Don't record duplicate entries
setopt HIST_IGNORE_ALL_DUPS   # Remove older duplicate entries
setopt HIST_REDUCE_BLANKS     # Remove superfluous blanks
setopt HIST_IGNORE_SPACE      # Don't record entries starting with space
setopt HIST_VERIFY            # Show command with history expansion before running
setopt APPEND_HISTORY         # Append to history file, don't overwrite
setopt INC_APPEND_HISTORY     # Write to history file immediately

# Directory navigation
setopt AUTO_CD                # cd by typing directory name
setopt AUTO_PUSHD             # Make cd push old directory onto stack
setopt PUSHD_IGNORE_DUPS      # Don't push duplicates
setopt PUSHD_SILENT           # Don't print directory stack
setopt PUSHD_TO_HOME          # Push to home when no argument

# Completion
setopt COMPLETE_IN_WORD       # Complete from both ends
setopt ALWAYS_TO_END          # Move cursor to end after completion
setopt AUTO_LIST              # List choices on ambiguous completion
setopt AUTO_MENU              # Show menu on successive tab presses
setopt AUTO_PARAM_SLASH       # Add trailing slash to directories
setopt COMPLETE_ALIASES       # Don't expand aliases before completion

# Correction
setopt CORRECT                # Try to correct spelling
setopt CORRECT_ALL            # Try to correct all arguments
# Don't correct tmux command (it's aliased by Oh-My-Zsh plugin)
# Note: This must be set after Oh-My-Zsh loads, so we'll handle it in integrations

# Other useful options
setopt EXTENDED_GLOB          # Extended globbing
setopt NO_BEEP                # Don't beep
setopt NO_CLOBBER             # Don't overwrite files with >
setopt NO_HUP                 # Don't kill jobs on shell exit
setopt NO_NOMATCH             # Don't error on unmatched patterns
setopt RM_STAR_WAIT           # Wait 10 seconds before rm *

# Enable completion system
# Use -C flag to skip security check (we handle this via 'dotfiles doctor')
# This prevents shell from exiting if there are permission issues
autoload -Uz compinit
compinit -C 2>/dev/null || compinit 2>/dev/null || true

# Completion waiting dots
COMPLETION_WAITING_DOTS="true"
