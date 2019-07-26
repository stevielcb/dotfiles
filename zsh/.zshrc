export LANG="en_US.UTF-8"

#zmodload zsh/zprof

export PATH="${HOME}/bin:${HOME}/go/bin:/usr/local/bin:${HOME}/.iterm2:$PATH"
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

function get_it_gurr() {
  timeout 2 curl \
    -L \
    -s \
    --compressed \
    $*
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
  do_git_update ~/.oh-my-zsh https://github.com/robbyrussell/oh-my-zsh

  # zsh-autosuggestions
  do_git_update ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions

  # Pathogen
  if ! [ -d ~/.vim/autoload ]; then
    mkdir -p ~/.vim/autoload ~/.vim/bundle && \
      curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
  fi;

  # fugitive.vim
  do_git_update ~/.vim/bundle/vim-fugitive https://github.com/tpope/vim-fugitive

  # vim-airline
  do_git_update ~/.vim/bundle/vim-airline https://github.com/vim-airline/vim-airline

  # vim-airline-themes
  do_git_update ~/.vim/bundle/vim-airline-themes https://github.com/vim-airline/vim-airline-themes

  # vim-json
  do_git_update ~/.vim/bundle/vim-json https://github.com/elzr/vim-json

  # iTerm2 Shell Integration
  if ! [ -f ~/.iterm2_shell_integration.zsh ]; then
    get_it_gurr https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | bash
  fi

  # iTerm2 Utilities
  if ! [ -d ~/.iterm2 ]; then
    mkdir -p ~/.iterm2
    UTILITIES=(imgcat imgls it2attention it2check it2copy it2dl it2getvar it2git it2setcolor it2setkeylabel it2ul it2universion)
    for U in "${UTILITIES[@]}"; do
      echo "Downloading ${U} ..."
      get_it_gurr "https://iterm2.com/utilities/${U}" > ~/.iterm2/${U} && chmod +x ~/.iterm2/${U}
    done
  fi
}

source ~/.zshrc.$(uname)

################################################################################
# powerlevel9k + 10k
################################################################################

POWERLEVEL9K_MODE="nerdfont-complete"
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

ZSH_PLUGINS+=(
  ansible
  aws
  colored-man-pages
  common-aliases
  copybuffer
  copydir
  copyfile
  dircycle
  docker
  encode64
  extract
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
  python
  redis-cli
  screen
  sudo
  urltools
  vagrant
  vscode
  web-search
  z
  zsh-autosuggestions
)

set -A plugins ${(v)ZSH_PLUGINS}

source $ZSH/oh-my-zsh.sh

source ${ZSH_SYNTAX}

################################################################################
# User configuration
################################################################################

export VISUAL="vim"
export EDITOR="${VISUAL}"
[ "${USER}" != "root" ] && export DEFAULT_USER="${USER}"

if ! [ -f ~/.giphy-api ]; then
  vared -p "Please enter your Giphy.com API key: " -c GIPHY_API_KEY
  echo -n "${GIPHY_API_KEY}" > ~/.giphy-api
else
  GIPHY_API_KEY=$(cat ~/.giphy-api)
fi

[[ -f ~/.iterm2_shell_integration.zsh ]] && source ~/.iterm2_shell_integration.zsh

export BAT_THEME="Monokai Extended Origin"
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(vim {})+abort'"

################################################################################
# Aliases
################################################################################

alias b="bat -p"
alias c="b"
alias du="ncdu -rex --color dark"
alias f="fzf --preview 'bat -p --color=always {}'"
alias http="http -F --style paraiso-dark"
alias ldir="exa -lahg --git --time-style=long-iso --only-dirs --icons"
alias l="exa -la --git --time-style=long-iso --group-directories-first --icons"
alias la="exa -lahg --git --time-style=long-iso --group-directories-first --icons"
alias ll="exa -l --git --time-style=long-iso --group-directories-first --icons"
alias lsize="l -ssize"
alias m="motd-client"
alias ping="prettyping --nolegend"
alias top="htop"

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

function xkcd() {
  RAND_COMIC=$[${RANDOM}%2000+1]
  XKCD_JSON=$(get_it_gurr https://xkcd.com/${RAND_COMIC}/info.0.json)
  IMG_URL=$(printf %s ${XKCD_JSON} | jq -r '.img')
  ALT_TXT=$(printf %s ${XKCD_JSON} | jq -r '.alt')
  get_it_gurr ${IMG_URL} | imgcat;
  echo "${ALT_TXT}";
}

function dogpic() {
  get_it_gurr $(get_it_gurr https://dog.ceo/api/breeds/image/random | jq -r '.message') | imgcat
}

function reaction_gif() {
  get_it_gurr $( \
    get_it_gurr http://replygif.net/random | \
    grep 'img src' | \
    sed -E 's/^.*img src="([^"]+).*$/\1/g' \
    ) | \
    imgcat
}

function giphy() {
  URL="http://api.giphy.com/v1/gifs/random?api_key=$(cat ${HOME}/.giphy-api)"
  [[ "$1" == "" ]] && echo "ERROR: No search tag provided" && return
  [[ "$2" == "" ]] || URL="${URL}&rating=${2}"
  URL="${URL}&tag=$(echo ${1} | sed 's/ /+/g')"
  get_it_gurr $( \
    get_it_gurr ${URL} | \
      jq -r '.data.images.original.url' \
    ) | \
    imgcat
}

################################################################################
# Login
################################################################################

motd-server &!
motd-client

#zprof
