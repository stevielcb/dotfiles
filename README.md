# dotfiles

Personal archive of user settings for macOS and Linux.

- [dotfiles](#dotfiles)
  - [Overview](#overview)
  - [Directory Structure](#directory-structure)
  - [Installation](#installation)

## Overview

This repository contains configuration files and scripts to set up a development environment on macOS and Linux. It includes settings for various tools and applications such as Vim, Tmux, Zsh, and more.

## Directory Structure

- `bin/`: Contains various shell scripts for tasks like formatting, linting, and more.
- `editorconfig/`: Contains the `.editorconfig` file for consistent coding styles.
- `git/`: Contains Git configuration files.
- `iterm2/`: Contains iTerm2 configuration files.
- `tmux/`: Contains Tmux configuration files.
- `vim/`: Contains Vim configuration files.
- `zsh/`: Contains Zsh configuration files.

## Installation

To set up the environment, you need to have `stow` installed. Then, run the following command to symlink the configuration files to your home directory:

```sh
stow <directory>
```
