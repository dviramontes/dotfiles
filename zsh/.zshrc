# Enable profiling: zmodload zsh/zprof  (then run: zprof)

# Oh My Zsh — theme unused (custom prompt below); skip update checks
ZSH_THEME=""
zstyle ':omz:update' mode disabled
# git aliases from OMZ; skip asdf plugin (forces broken shims ahead of mise/nvm)
plugins=(git)
ZSH_DISABLE_COMPFIX=true
source "$HOME/.oh-my-zsh/oh-my-zsh.sh"

# Compact prompt: cwd + git branch/status (+ ahead/behind)
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:git:*' unstagedstr '*'
zstyle ':vcs_info:git:*' formats ' %F{yellow}[%b%c%u]%f'
zstyle ':vcs_info:git:*' actionformats ' %F{yellow}[%b|%a%c%u]%f'

git_ahead_behind() {
    local ahead behind
    GIT_SYNC=''
    [[ -n ${vcs_info_msg_0_} ]] || return
    read -r ahead behind <<< "$(command git rev-list --left-right --count HEAD...@{upstream} 2>/dev/null)"
    (( ahead > 0 )) && GIT_SYNC+=" %F{green}↑${ahead}%f"
    (( behind > 0 )) && GIT_SYNC+=" %F{red}↓${behind}%f"
}

prompt_remote_host() {
    PROMPT_HOST=''
    [[ -n $SSH_CONNECTION ]] && PROMPT_HOST='%F{red}%m%f '
}

precmd_functions+=(vcs_info git_ahead_behind prompt_remote_host)
[[ -o interactive ]] && PS1='%F{242}%D{%H:%M}%f ${PROMPT_HOST}%F{cyan}%1~%f${vcs_info_msg_0_}${GIT_SYNC} %# '

# fzf (optional)
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# direnv
(( $+commands[direnv] )) && eval "$(direnv hook zsh)"

# Editor / nvim paths
export EDITOR=nvim
export VISUAL=nvim
export VIMCONF=$HOME/.config/nvim
export VIMDATA=$HOME/.local/share/nvim
export XDG_CONFIG_HOME="$HOME/.config"

# User shell fragments
source ~/.alias.sh
[[ -f ~/.secrets.sh ]] && source ~/.secrets.sh
[[ -f ~/.config.sh ]] && source ~/.config.sh
source ~/.functions.sh

# --- PATH ---
typeset -U path PATH

path=(
  $HOME/bin
  $HOME/.local/bin
  $HOME/.zvm/bin
  $HOME/.codeium/windsurf/bin
  $HOME/go/bin
  $path
)

# Rust: avoid `rustup which` subprocess
if [[ -d $HOME/.cargo/bin ]]; then
  path=($HOME/.cargo/bin $path)
elif [[ -x $HOME/.rustup/toolchains/stable-aarch64-apple-darwin/bin/cargo ]]; then
  path=($HOME/.rustup/toolchains/stable-aarch64-apple-darwin/bin $path)
fi

# asdf CLI is a brew binary (0.20+). Keep shims available but NOT ahead of mise.
# Tools without a version in .tool-versions will miss via shim — prefer mise/nvm.
[[ -d $HOME/.asdf/shims ]] && path+=($HOME/.asdf/shims)

# Homebrew extras (arm64)
if [[ $(uname -m) == arm64 ]]; then
  path=(/opt/homebrew/opt/libpq/bin /opt/homebrew/opt/postgresql@18/bin $path)
  [[ -f /opt/homebrew/etc/profile.d/z.sh ]] && source /opt/homebrew/etc/profile.d/z.sh
else
  [[ -f /usr/local/etc/profile.d/z.sh ]] && source /usr/local/etc/profile.d/z.sh
fi

# Ensure core system commands remain reachable without shadowing brew/user bins
for _sys in /usr/bin /bin /usr/sbin /sbin; do
  (( path[(Ie)$_sys] )) || path+=($_sys)
done
unset _sys

# Warp: absolute dirname so hooks work if PATH is temporarily altered
if [[ ${TERM_PROGRAM:-} == WarpTerminal && -x /usr/bin/dirname ]]; then
  dirname() { /usr/bin/dirname "$@"; }
fi

export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# nvm — PATH fallback for node when mise doesn't provide it; lazy-load nvm CLI only
export NVM_DIR="$HOME/.nvm"
if [[ -d $NVM_DIR/versions/node ]]; then
  local_nvm_ver=$(/bin/ls -1 "$NVM_DIR/versions/node" | sort -V | tail -1)
  [[ -n $local_nvm_ver ]] && path=($NVM_DIR/versions/node/$local_nvm_ver/bin $path)
fi
nvm() {
  unfunction nvm 2>/dev/null
  [[ -s $NVM_DIR/nvm.sh ]] && . $NVM_DIR/nvm.sh
  nvm "$@"
}

# Elixir escripts — static paths (no find on every startup)
_elixir_escripts=(
  ${ASDF_DATA_DIR:-$HOME/.asdf}/installs/elixir/1.18.2-otp-27/.mix/escripts
  ${ASDF_DATA_DIR:-$HOME/.asdf}/installs/elixir/1.18.2/.mix/escripts
  $HOME/.mix/escripts
)
for _d in $_elixir_escripts; do
  [[ -d $_d ]] && path=($_d $path)
done
unset _d _elixir_escripts

# task completion — lazy
task() {
  unfunction task 2>/dev/null
  if (( $+commands[task] )) && [[ -o interactive ]]; then
    eval "$(command task --completion zsh 2>/dev/null)"
  fi
  command task "$@"
}

# mise — shims avoid per-directory hooks for faster startup
if (( $+commands[mise] )); then
  eval "$(mise activate zsh --shims)"
elif [[ -x $HOME/.local/share/mise/bin/mise ]]; then
  path=($HOME/.local/share/mise/bin $path)
  eval "$(mise activate zsh --shims)"
fi
