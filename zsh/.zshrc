export LANG="en_US.UTF-8"

#zmodload zsh/zprof

export PATH="${HOME}/bin:${HOME}/go/bin:/usr/local/bin:${HOME}/.iterm2:/usr/local/sbin:$PATH"
for USERBIN in ~/bin ~/go/bin; do
  mkdir -p ${USERBIN}
done

################################################################################
# Load OS-Specific Functions
################################################################################

PREREQS=~/.dotfiles-prerequisites

function cmd_exists() {
  return `which $1 2>&1 >/dev/null`
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
    git clone --depth 1 ${2} ${1}
  else
    (cd ${1} && git pull)
  fi
}

function install_prereqs_common() {
  # Oh-My-ZSH!
  do_git_update ~/.oh-my-zsh https://github.com/robbyrussell/oh-my-zsh

  # zsh-autosuggestions
  do_git_update ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions

  # zsh-morpho screensaver
  do_git_update ~/.oh-my-zsh/custom/plugins/zsh-morpho https://github.com/psprint/zsh-morpho

  # zsh autopair plugin
  do_git_update ~/.oh-my-zsh/custom/plugins/zsh-autopair https://github.com/hlissner/zsh-autopair

  # zsh fast syntax highlighting
  do_git_update ~/.oh-my-zsh/custom/plugins/fast-syntax-highlighting https://github.com/zdharma/fast-syntax-highlighting

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

  # vim-arpeggio
  do_git_update ~/.vim/bundle/vim-arpeggio https://github.com/kana/vim-arpeggio

  # vim senshi (smart Python syntax highlighter)
  do_git_update ~/.vim/bundle/semshi https://github.com/numirias/semshi

  # vim-json
  do_git_update ~/.vim/bundle/vim-json https://github.com/elzr/vim-json

  # NERDTree
  do_git_update ~/.vim/bundle/nerdtree https://github.com/scrooloose/nerdtree

  # NERDTree git plugin
  do_git_update ~/.vim/bundle/nerdtree-git-plugin https://github.com/Xuyuanp/nerdtree-git-plugin

  # The NERD Commenter
  do_git_update ~/.vim/bundle/nerdcommenter https://github.com/scrooloose/nerdcommenter

  # Tabular
  do_git_update ~/.vim/bundle/tabular https://github.com/godlygeek/tabular

  # Emmet-vim
  do_git_update ~/.vim/bundle/emmet-vim https://github.com/mattn/emmet-vim

  # vim-gitgutter
  do_git_update ~/.vim/bundle/vim-gitgutter https://github.com/airblade/vim-gitgutter

  # vim-obsession
  do_git_update ~/.vim/bundle/vim-obsession https://github.com/tpope/vim-obsession

  # indentLine
  #do_git_update ~/.vim/bundle/indentLine https://github.com/Yggdroot/indentLine

  # Indent Guides
  do_git_update ~/.vim/bundle/vim-indent-guides https://github.com/nathanaelkane/vim-indent-guides

  # fzf.vim
  do_git_update ~/.vim/bundle/fzf.vim https://github.com/junegunn/fzf.vim

  # Tagbar
  do_git_update ~/.vim/bundle/tagbar https://github.com/majutsushi/tagbar

  # VimDevIcons
  do_git_update ~/.vim/bundle/vim-devicons https://github.com/ryanoasis/vim-devicons

  # PaperColor Theme
  do_git_update ~/.vim/bundle/papercolor-theme https://github.com/NLKNguyen/papercolor-theme

  # tmux plugin manager
  do_git_update ~/.tmux/plugins/tpm https://github.com/tmux-plugins/tpm

  # tmux sensible
  do_git_update ~/.tmux/plugins/tmux-sensible https://github.com/tmux-plugins/tmux-sensible

  # tmux resurrect
  do_git_update ~/.tmux/plugins/tmux-resurrect https://github.com/tmux-plugins/tmux-resurrect

  # tmux continuum
  do_git_update ~/.tmux/plugins/tmux-continuum https://github.com/tmux-plugins/tmux-continuum

  # tmux copycat
  do_git_update ~/.tmux/plugins/tmux-copycat https://github.com/tmux-plugins/tmux-copycat

  # tmux urlview
  do_git_update ~/.tmux/plugins/tmux-urlview https://github.com/tmux-plugins/tmux-urlview

  # tmux vim focus events
  do_git_update ~/.vim/bundle/vim-tmux-focus-events https://github.com/tmux-plugins/vim-tmux-focus-events

  # tmux "pain" control
  do_git_update ~/.tmux/plugins/tmux-pain-control https://github.com/tmux-plugins/tmux-pain-control

  # tmux sessionist
  do_git_update ~/.tmux/plugins/tmux-sessionist https://github.com/tmux-plugins/tmux-sessionist

  # tmux better mouse mode
  do_git_update ~/.tmux/plugins/tmux-better-mouse-mode https://github.com/NHDaly/tmux-better-mouse-mode

  # tmux taskwarrior
  do_git_update ~/.tmux/plugins/tmux-tasks https://github.com/chriszarate/tmux-tasks

  # tmux prefix highlight
  do_git_update ~/.tmux/plugins/tmux-prefix-highlight https://github.com/tmux-plugins/tmux-prefix-highlight

  # tmux extracto
  do_git_update ~/.tmux/plugins/extrakto https://github.com/laktak/extrakto

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

  # Neovim auto-sourcing .vimrc + .vim
  if ! [ -f ~/.config/nvim/init.vim ]; then
    mkdir -p ~/.config/nvim;
    cat > ~/.config/nvim/init.vim << "EOF"
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
EOF
  fi
}

source ~/.zshrc.$(uname)

################################################################################
# User configuration
################################################################################

cmd_exists nvim && NVIM=$(which nvim)

export VISUAL="${NVIM:-vim}"
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

###############
#### tmux #####
###############
[[ $(whoami) != "root" ]] && ZSH_TMUX_AUTOSTART=true

################################################################################
# powerlevel9k + 10k
################################################################################

POWERLEVEL9K_MODE="nerdfont-complete"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(status context dir vcs)
POWERLEVEL9K_HIDE_BRANCH_ICON=true
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"
POWERLEVEL9K_SHORTEN_DELIMITER=""

POWERLEVEL9K_LOAD_NORMAL_BACKGROUND='113'
POWERLEVEL9K_LOAD_WARNING_BACKGROUND='221'
POWERLEVEL9K_LOAD_CRITICAL_BACKGROUND='203'
POWERLEVEL9K_OS_ICON_FOREGROUND='116'

POWERLEVEL9K_CONTEXT_TEMPLATE="%n"

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
  fast-syntax-highlighting
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
  tmux
  urltools
  vagrant
  vscode
  web-search
  z
  zsh-autopair
  zsh-autosuggestions
)

set -A plugins ${(v)ZSH_PLUGINS}

source $ZSH/oh-my-zsh.sh

#source ${ZSH_SYNTAX}

################################################################################
# Aliases
################################################################################

alias b="bat -p"
alias c="b"
alias du="ncdu -rex --color dark"
alias f="fzf --preview 'bat -p --color=always {}'"
alias h="nocorrect howdoi"
alias http="http -F --style paraiso-dark"
alias ldir="exa -lahg --git --time-style=long-iso --only-dirs --icons"
alias l="exa -la --git --time-style=long-iso --group-directories-first --icons"
alias la="exa -lahg --git --time-style=long-iso --group-directories-first --icons"
alias ll="exa -l --git --time-style=long-iso --group-directories-first --icons"
alias lp="lpass show -c --password \$(lpass ls | fzf | awk '{print \$(NF)}' | sed 's/\]//g')"
alias lpn="lpass show -c --notes \$(lpass ls | fzf | awk '{print \$(NF)}' | sed 's/\]//g')"
alias lpu="lpass show -c --username \$(lpass ls | fzf | awk '{print \$(NF)}' | sed 's/\]//g')"
alias lsize="l -ssize"
alias m="motd-client"
alias ping="prettyping --nolegend"
alias rg="rg -p"
alias task="nocorrect task"
alias td="tmux detach"
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

disable r;
function r() {
  DIM=($(tmux list-panes -F "#{pane_height} #{pane_width} #{pane_active}" | grep 1$ | awk '{print $1" "$2}'))
  if [[ $DIM ]]; then
    stty cols ${DIM[2]} rows ${DIM[1]}
  fi
}

# Have to store real path to command since our function needs to call it and not
# end up in a recursive loop calling itself
REAL_VIM=$(which ${VISUAL})
# This override function causes vim to open the real file path when opening symlinks.
# That is so that the vim plugins can get the git info for a file when the symlink exists
# outside of the repo dir.
function vim() {
  # macOS needs coreutils' greadlink because the built-in version doesn't support '-f'
  cmd_exists greadlink && RL=greadlink || RL=readlink

  ARGS=()
  for f in $*; do
    [[ -h ${f} ]] && ARGS+=(`${RL} -f ${f}`) || ARGS+=($f)
  done

  ${REAL_VIM} ${ARGS[@]}
}

################################################################################
# fzf
################################################################################

# Install fuzzy completion if it hasn't been done yet, but only for brewers
if [ -d /usr/share/fzf ]; then
  source /usr/share/fzf/completion.zsh;
  source /usr/share/fzf/key-bindings.zsh;
else
  [ ! -f ~/.fzf.zsh ] && (( $+commands[brew] )) && $(brew --prefix)/opt/fzf/install
  # Source fuzzy completion if it's there
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fi
# CTRL+O will open the selected file in an editor
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(${VISUAL} {})+abort'"
# Make sure to include hidden files but I don't care about .git or its children
# https://i.kym-cdn.com/photos/images/original/001/080/653/288.png
export FZF_DEFAULT_COMMAND="rg --hidden --files --smart-case --glob '!.git/*' 2>/dev/null"

################################################################################
# Login
################################################################################

# # Only start motd-server when you aren't in an SSH session
# (( ${+SSH_CLIENT} )) && motd-server &!
# # Only run motd-client if motd-server is detected
# pgrep motd-server 2>&1 >/dev/null && motd-client

# Show some ponies, but only if there's room
TERM_HEIGHT=$(tput lines)
if [ $TERM_HEIGHT -gt 20 ]; then
  fortune | ponysay
fi

#zprof
