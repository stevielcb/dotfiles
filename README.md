# dotfiles

Personal archive of user settings for macOS and Linux.

- [dotfiles](#dotfiles)
  - [Overview](#overview)
  - [Architecture](#architecture)
    - [Runtime vs Bootstrap](#runtime-vs-bootstrap)
  - [Directory Structure](#directory-structure)
  - [Installation](#installation)
    - [Prerequisites](#prerequisites)
    - [Step 1: Clone and Stow](#step-1-clone-and-stow)
    - [Step 2: Bootstrap](#step-2-bootstrap)
    - [Step 3: Restart Your Shell](#step-3-restart-your-shell)
  - [Usage](#usage)
    - [Updating Plugins](#updating-plugins)
    - [Checking System Health](#checking-system-health)
    - [Getting Help](#getting-help)
  - [What Runs at Shell Startup?](#what-runs-at-shell-startup)
  - [Troubleshooting](#troubleshooting)
    - [Shell startup is slow](#shell-startup-is-slow)
    - [Completion security warnings](#completion-security-warnings)
    - [Plugins not working](#plugins-not-working)
    - [Tmux status line not showing](#tmux-status-line-not-showing)
    - [Vim plugins not loading](#vim-plugins-not-loading)
  - [Customization](#customization)
    - [Adding New Plugins](#adding-new-plugins)
    - [Modifying Configuration](#modifying-configuration)
  - [Security Notes](#security-notes)
  - [License](#license)

## Overview

This repository contains configuration files and scripts to set up a development environment on macOS and Linux. It includes settings for various tools and applications such as Vim, Tmux, Zsh, and more.

## Architecture

The dotfiles are organized into two main categories:

- **Runtime configuration**: Fast, non-interactive shell configuration that sources quickly at startup
- **Bootstrap/update tools**: Explicit commands to install packages, sync plugins, and manage the environment

### Runtime vs Bootstrap

- **Runtime** (`~/.zshrc`, `~/.zprofile`, etc.): Loaded every time you open a shell. These files are optimized for speed and contain no network calls, package installations, or interactive prompts.
- **Bootstrap** (`bin/dotfiles`): Run explicitly when setting up a new machine or updating plugins. Handles all package installation, git clones, and tool setup.

## Directory Structure

- `bin/`: Contains various shell scripts for tasks like formatting, linting, and the main `dotfiles` CLI
- `editorconfig/`: Contains the `.editorconfig` file for consistent coding styles
- `git/`: Contains Git configuration files
- `iterm2/`: Contains iTerm2 configuration files
- `tmux/`: Contains Tmux configuration files
- `vim/`: Contains Vim configuration files
- `zsh/`: Contains Zsh configuration files
  - `.zshrc`: Main loader (sources modular configs)
  - `.zshrc.d/`: Modular configuration files (options, path, env, aliases, functions, integrations)
  - `.zshrc.Darwin`: macOS-specific runtime config
  - `.zshrc.Linux`: Linux-specific runtime config
  - `.zprofile`: Login shell profile (MOTD env vars)

## Installation

### Prerequisites

- `stow` (install via Homebrew: `brew install stow` or your Linux package manager)
- `git`
- `curl`
- `zsh`

### Step 1: Clone and Stow

```sh
# Clone the repository
git clone https://github.com/stevielcb/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Symlink configuration files to your home directory
stow zsh tmux vim git bin iterm2 editorconfig
```

This creates symlinks in your home directory pointing to the files in this repository.

### Step 2: Bootstrap

Run the bootstrap command to install all prerequisites, plugins, and tools:

```sh
dotfiles bootstrap
```

This will:

- Install system packages (Homebrew packages on macOS, distro packages on Linux)
- Clone Oh-My-Zsh and plugins
- Install Vim plugins
- Install Tmux plugins
- Set up language tools (Go, Python, Node.js packages, etc.)
- Install iTerm2 integration (macOS only)

**Note**: The bootstrap process may take several minutes and requires network access. It will prompt for `sudo` when needed.

### Step 3: Restart Your Shell

After bootstrap completes, restart your shell or run:

```sh
source ~/.zshrc
```

## Usage

### Updating Plugins

To update all plugins and tools:

```sh
dotfiles update
```

This updates:

- Oh-My-Zsh and plugins
- Vim plugins
- Tmux plugins (via TPM)

### Checking System Health

Run the doctor command to check for issues:

```sh
dotfiles doctor
```

This checks:

- Zsh completion security (compaudit)
- Required commands availability
- PATH configuration
- Plugin installation status

### Getting Help

```sh
dotfiles help
```

## What Runs at Shell Startup?

**Nothing heavy!** Your shell startup is now fast and non-interactive:

- ✅ Environment variables (PATH, EDITOR, etc.)
- ✅ Zsh options and completion
- ✅ Aliases and functions
- ✅ Oh-My-Zsh and plugins (if installed)
- ✅ Powerlevel10k prompt
- ✅ fzf integration
- ✅ Tmux autostart (if configured)

**Not at startup:**

- ❌ Package installations
- ❌ Network calls
- ❌ Git clones/pulls
- ❌ Interactive prompts (except lazy-loaded Giphy API key)

## Troubleshooting

### Shell startup is slow

If your shell is slow to start, check:

1. Run `dotfiles doctor` to check for issues
2. Check if Oh-My-Zsh is installed: `ls ~/.oh-my-zsh`
3. Check for large history files: `ls -lh ~/.zsh_history`
4. Profile startup time: `zsh -xvic exit 2>&1 | head -20`

### Completion security warnings

If you see warnings about insecure completion directories:

```sh
dotfiles doctor
```

This will show you which directories need their permissions fixed. Fix them with:

```sh
chmod -R go-w <directory>
```

### Plugins not working

If plugins aren't working:

1. Run `dotfiles bootstrap` to ensure everything is installed
2. Check `dotfiles doctor` for missing dependencies
3. Verify Oh-My-Zsh is installed: `test -d ~/.oh-my-zsh && echo "OK" || echo "Missing"`

### Tmux status line not showing

If tmux status line isn't rendering correctly:

1. Ensure tmux plugins are installed: `dotfiles bootstrap`
2. Install TPM plugins: Press `Prefix + I` in tmux
3. Check status scripts are executable: `ls -l ~/bin/status-*.sh`

### Vim plugins not loading

If Vim plugins aren't loading:

1. Ensure Pathogen is installed: `test -f ~/.vim/autoload/pathogen.vim`
2. Run `dotfiles bootstrap` to install all plugins
3. Check Vim runtime path: `vim --version | grep runtimepath`

## Customization

### Adding New Plugins

1. **Oh-My-Zsh plugins**: Add to the `ZSH_PLUGINS` array in `zsh/.zshrc`. For plugins that only make sense on one OS, append to it from `zsh/.zshrc.Darwin` or `zsh/.zshrc.Linux` with `ZSH_PLUGINS+=(...)` — those files are sourced after the base array is defined and before it is handed to Oh-My-Zsh
2. **Vim plugins**: Add git clone command to `bin/dotfiles` `install_prereqs_common()` function
3. **Tmux plugins**: Add to `tmux/.tmux.conf` `@plugin` list

### Modifying Configuration

Since files are symlinked via `stow`, you can edit them directly in `~/dotfiles/` and changes will be reflected immediately. Commit changes back to your repository.

## Security Notes

- Remote installers (iTerm2 integration, Homebrew on Linux) are downloaded to a file and then run, never piped straight from `curl` into a shell
- Giphy API key is stored in `~/.giphy-api` with `600` permissions
- Zsh completion security checks are enabled (use `dotfiles doctor` to fix issues)
- All scripts use proper quoting and avoid `eval` where possible
- `bootstrap` calls `sudo` for distro packages and `gem install`; read `bin/dotfiles` before running it on a machine you do not control

## License

See [LICENSE](LICENSE) file for details.
