export PATH="${HOME}/bin:${HOME}/go/bin:/usr/local/bin:$PATH"
for USERBIN in ~/bin ~/go/bin; do
  mkdir -p ${USERBIN}
done

################################################################################
# Load OS-Specific Functions
################################################################################

PREREQS=~/.dotfiles-prerequisites

function cmd_exists() {
  return `which $1 >/dev/null`
}

function do_git_update() {
  if ! [ -d ${1} ]; then
    git clone ${2} ${1}
  else
    (cd ${1} && git pull)
  fi
}

function install_prereqs_common() {
  # Oh-My-ZSH!
  do_git_update ~/.oh-my-zsh https://github.com/robbyrussell/oh-my-zsh.git

  # zsh-autosuggestions
  do_git_update ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions

  # Pathogen
  if ! [ -d ~/.vim/autoload ]; then
    mkdir -p ~/.vim/autoload ~/.vim/bundle && \
      curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
  fi;
}

source ~/.zshrc.$(uname)

################################################################################
# powerlevel9k + 10k
################################################################################

POWERLEVEL9K_MODE="awesome-patched"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(status os_icon load ram newline context dir vcs)
POWERLEVEL9K_HIDE_BRANCH_ICON=true
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"
POWERLEVEL9K_SHORTEN_DELIMITER=""
POWERLEVEL9K_PROMPT_ON_NEWLINE=true

POWERLEVEL9K_LOAD_NORMAL_BACKGROUND='113'
POWERLEVEL9K_LOAD_WARNING_BACKGROUND='221'
POWERLEVEL9K_LOAD_CRITICAL_BACKGROUND='203'
POWERLEVEL9K_OS_ICON_FOREGROUND='116'

POWERLEVEL9K_DIR_HOME_FOREGROUND='195'
POWERLEVEL9K_DIR_HOME_BACKGROUND='023'
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND='195'
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND='023'
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND='013'
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND='052'
POWERLEVEL9K_DIR_ETC_FOREGROUND='229'
POWERLEVEL9K_DIR_ETC_BACKGROUND='166'

POWERLEVEL9K_KUBECONTEXT_FOREGROUND='146'
POWERLEVEL9K_KUBECONTEXT_BACKGROUND='053'

POWERLEVEL9K_HISTORY_BACKGROUND='025'
POWERLEVEL9K_HISTORY_FOREGROUND='015'

POWERLEVEL9K_TIME_FOREGROUND='158'
POWERLEVEL9K_TIME_BACKGROUND='235'

POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='000'
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='154'
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='000'
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='178'
POWERLEVEL9K_VCS_CLEAN_FOREGROUND='000'
POWERLEVEL9K_VCS_CLEAN_BACKGROUND='034'

POWERLEVEL9K_RAM_BACKGROUND='035'

################################################################################
# Oh My ZSH!
################################################################################

export ZSH=~/.oh-my-zsh
ZSH_DISABLE_COMPFIX="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
set -A plugins ${(v)ZSH_PLUGINS}

source $ZSH/oh-my-zsh.sh

source ${ZSH_SYNTAX}

################################################################################
# User configuration
################################################################################

export VISUAL="vim"
export EDITOR="${VISUAL}"
[ "${USER}" != "root" ] && export DEFAULT_USER="${USER}"

################################################################################
# Aliases
################################################################################

alias ll="exa -l --git --time-style=long-iso --group-directories-first"
alias l="exa -la --git --time-style=long-iso --group-directories-first"
alias la="exa -lahg --git --time-style=long-iso --group-directories-first"

################################################################################
# Functions
################################################################################

function ginit {
  CUR_DIR_NAME=$(basename `pwd`)
  git init
  git add .
  git commit -m "Initial commit"
  git remote add origin git@github.com:stevenwoah/${CUR_DIR_NAME}.git
  git remote -v
  git push -u origin master
}

function mit {
  cat > LICENSE << EOF
MIT License

Copyright (c) $(date +"%Y") Steven O'Donnell

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF
}

################################################################################
# Login
################################################################################

fortune | ponysay
