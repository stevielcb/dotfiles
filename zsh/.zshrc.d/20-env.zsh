# Environment variables and language settings

# Locale
export LANG="en_US.UTF-8"

# Editor configuration
if command -v nvim >/dev/null 2>&1; then
  export VISUAL="nvim"
elif command -v vim >/dev/null 2>&1; then
  export VISUAL="vim"
else
  export VISUAL="vi"
fi
export EDITOR="${VISUAL}"

# User name (for powerlevel10k)
[[ "${USER}" != "root" ]] && export DEFAULT_USER="${USER}"

# Bat theme
export BAT_THEME="Monokai Extended Origin"

# Node options
export NODE_OPTIONS="--no-warnings"

# Poetry config
if [[ -d "${HOME}/.config/poetry" ]]; then
  export POETRY_CONFIG_DIR="${HOME}/.config/poetry"
fi

# Java (macOS-specific)
if [[ -d "/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home" ]]; then
  export JAVA_HOME="/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home"
fi

# Android SDK (macOS-specific)
if [[ -d "$HOME/Library/Android/sdk" ]]; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  path=(
    "$ANDROID_HOME/emulator"
    "$ANDROID_HOME/platform-tools"
    $path
  )
fi

# NVM: set the directory only. nvm itself is lazy-loaded by the nvm() function
# in 40-functions.zsh, so sourcing it here would defeat the purpose.
export NVM_DIR="$HOME/.nvm"
