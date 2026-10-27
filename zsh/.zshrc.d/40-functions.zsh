# Shell functions

# Safe command existence check
cmd_exists() {
  command -v -- "$1" >/dev/null 2>&1
}

# Safe curl wrapper (for runtime use, not bootstrap)
safe_curl() {
  local url="$1"
  shift
  curl \
    --fail \
    --show-error \
    --location \
    --compressed \
    --connect-timeout 10 \
    --max-time 30 \
    "$@" \
    "$url" 2>/dev/null || return 1
}

# Git initialization helper
function ginit {
  local cur_dir_name
  cur_dir_name=$(basename "$(pwd)")
  git init
  git add .
  git commit -m "Initial commit"
  git remote add origin "git@github.com:stevielcb/${cur_dir_name}.git"
  git remote -v
  git push -u origin master
}

# MIT License generator
function mit {
  cat > LICENSE << EOF
MIT License

Copyright (c) $(date +"%Y") Stevie Ballantines

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

# XKCD random comic viewer
function xkcd() {
  local rand_comic
  local xkcd_json
  local img_url
  local alt_txt
  
  rand_comic=$((RANDOM % 2000 + 1))
  xkcd_json=$(safe_curl "https://xkcd.com/${rand_comic}/info.0.json") || return 1
  
  img_url=$(printf '%s' "${xkcd_json}" | jq -r '.img' 2>/dev/null) || return 1
  alt_txt=$(printf '%s' "${xkcd_json}" | jq -r '.alt' 2>/dev/null) || return 1
  
  safe_curl "${img_url}" | imgcat 2>/dev/null || return 1
  echo "${alt_txt}"
}

# Dog picture viewer
function dogpic() {
  local api_response
  local img_url
  
  api_response=$(safe_curl "https://dog.ceo/api/breeds/image/random") || return 1
  img_url=$(printf '%s' "${api_response}" | jq -r '.message' 2>/dev/null) || return 1
  safe_curl "${img_url}" | imgcat 2>/dev/null || return 1
}

# Reaction GIF viewer
function reaction_gif() {
  local html_content
  local img_url
  
  html_content=$(safe_curl "http://replygif.net/random") || return 1
  img_url=$(printf '%s' "${html_content}" | grep 'img src' | sed -E 's/^.*img src="([^"]+).*$/\1/g' | head -1) || return 1
  safe_curl "${img_url}" | imgcat 2>/dev/null || return 1
}

# Giphy search (lazy API key loading)
function giphy() {
  local giphy_api_key
  local url
  local tag
  local rating="${2:-}"
  
  if [[ -z "${1:-}" ]]; then
    echo "ERROR: No search tag provided" >&2
    return 1
  fi
  
  tag=$(echo "${1}" | sed 's/ /+/g')
  
  # Lazy load API key (prompt only when function is called)
  if [[ ! -f ~/.giphy-api ]]; then
    vared -p "Please enter your Giphy.com API key: " -c giphy_api_key
    printf '%s' "${giphy_api_key}" > ~/.giphy-api
    chmod 600 ~/.giphy-api
  fi
  
  giphy_api_key=$(cat ~/.giphy-api)
  url="https://api.giphy.com/v1/gifs/random?api_key=${giphy_api_key}&tag=${tag}"
  
  if [[ -n "${rating}" ]]; then
    url="${url}&rating=${rating}"
  fi
  
  local api_response
  local img_url
  
  api_response=$(safe_curl "${url}") || return 1
  img_url=$(printf '%s' "${api_response}" | jq -r '.data.images.original.url' 2>/dev/null) || return 1
  
  safe_curl "${img_url}" | imgcat 2>/dev/null || return 1
}

# Tmux resize helper
disable r
function r() {
  local dim
  local dim_array
  
  dim=$(tmux list-panes -F "#{pane_height} #{pane_width} #{pane_active}" | grep "1$" | awk '{print $1" "$2}' | head -1)
  
  if [[ -n "${dim}" ]]; then
    dim_array=(${=dim})
    stty cols "${dim_array[2]}" rows "${dim_array[1]}" 2>/dev/null || true
  fi
}

# Vim wrapper that resolves symlinks
function vim() {
  local real_vim
  local readlink_cmd
  local args=()
  local arg
  
  real_vim=$(command -v "${VISUAL:-vim}") || {
    echo "Error: ${VISUAL:-vim} not found" >&2
    return 1
  }
  
  # macOS needs greadlink, Linux has readlink with -f
  if command -v greadlink >/dev/null 2>&1; then
    readlink_cmd="greadlink"
  else
    readlink_cmd="readlink"
  fi
  
  for arg in "$@"; do
    if [[ -h "${arg}" ]]; then
      if [[ "${readlink_cmd}" == "greadlink" ]]; then
        args+=("$(greadlink -f "${arg}")")
      else
        args+=("$(readlink -f "${arg}")")
      fi
    else
      args+=("${arg}")
    fi
  done
  
  "${real_vim}" "${args[@]}"
}

# Lazy NVM loader
function nvm() {
  unset -f nvm
  
  # Source NVM if available
  if [[ -s "${NVM_DIR}/nvm.sh" ]]; then
    source "${NVM_DIR}/nvm.sh"
  elif [[ -s "/usr/local/opt/nvm/nvm.sh" ]]; then
    source "/usr/local/opt/nvm/nvm.sh"
  elif [[ -s "$HOME/.nvm/nvm.sh" ]]; then
    source "$HOME/.nvm/nvm.sh"
  else
    echo "Error: nvm not found" >&2
    return 1
  fi
  
  # Call nvm with arguments
  nvm "$@"
}
