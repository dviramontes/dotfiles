# Enable profiling: zmodload zsh/zprof  (then run: zprof)

# Oh My Zsh — theme unused (custom prompt below); skip update checks
ZSH_THEME=""
zstyle ':omz:update' mode disabled
# git aliases from OMZ; skip asdf plugin (forces broken shims ahead of mise/nvm)
plugins=(git)
ZSH_DISABLE_COMPFIX=true
if [[ -r ${ZSH:-$HOME/.oh-my-zsh}/oh-my-zsh.sh ]]; then
  source "${ZSH:-$HOME/.oh-my-zsh}/oh-my-zsh.sh"
else
  autoload -Uz compinit
  compinit
fi

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
if [[ -z $EDITOR ]]; then
  if (( $+commands[nvim] )); then
    export EDITOR=nvim
  else
    export EDITOR=vi
  fi
fi
export VISUAL="${VISUAL:-$EDITOR}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export VIMCONF="$XDG_CONFIG_HOME/nvim"
export VIMDATA="$XDG_DATA_HOME/nvim"

# User shell fragments
[[ -f ~/.alias.sh ]] && source ~/.alias.sh
[[ -f ~/.secrets.sh ]] && source ~/.secrets.sh
[[ -f ~/.config.sh ]] && source ~/.config.sh
[[ -f ~/.functions.sh ]] && source ~/.functions.sh

# --- PATH ---
typeset -U path PATH

path=(
  $HOME/bin
  $HOME/.local/bin
  $HOME/.bun/bin
  $HOME/.zvm/bin
  $HOME/.codeium/windsurf/bin
  $HOME/go/bin
  $path
)

# Rust: avoid `rustup which` subprocess
if [[ -d ${CARGO_HOME:-$HOME/.cargo}/bin ]]; then
  path=("${CARGO_HOME:-$HOME/.cargo}/bin" $path)
fi

# asdf CLI is a brew binary (0.20+). Keep shims available but NOT ahead of mise.
# Tools without a version in .tool-versions will miss via shim — prefer mise/nvm.
[[ -d $HOME/.asdf/shims ]] && path+=($HOME/.asdf/shims)

# Homebrew extras: discover the prefix on macOS or Linux, if installed.
if (( $+commands[brew] )); then
  _brew_prefix=$(command brew --prefix)
  if [[ -n $_brew_prefix ]]; then
    for _d in "$_brew_prefix/opt/libpq/bin" "$_brew_prefix/opt/postgresql@18/bin"; do
      [[ -d $_d ]] && path=($_d $path)
    done
    [[ -r $_brew_prefix/etc/profile.d/z.sh ]] && source "$_brew_prefix/etc/profile.d/z.sh"
  fi
  unset _brew_prefix _d
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
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
_nvm_versions=("$NVM_DIR"/versions/node/v[0-9]*(N/nOn))
[[ -n ${_nvm_versions[1]} ]] && path=("${_nvm_versions[1]}/bin" $path)
unset _nvm_versions
if [[ -s $NVM_DIR/nvm.sh ]]; then
  nvm() {
    unfunction nvm 2>/dev/null
    source "$NVM_DIR/nvm.sh"
    nvm "$@"
  }
fi

# bun completions (optional; needs compdef from OMZ)
[[ -s $HOME/.bun/_bun ]] && source "$HOME/.bun/_bun"

# Elixir escripts — discover installed versions without hard-coded releases.
_elixir_escripts=(
  "${ASDF_DATA_DIR:-$HOME/.asdf}"/installs/elixir/*/.mix/escripts(N/)
  "${MIX_HOME:-$HOME/.mix}/escripts"
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

# mise — primary version manager (per-directory tools via chpwd hook)
# Faster alternative without directory hooks: eval "$(mise activate zsh --shims)"
if (( $+commands[mise] )); then
  eval "$(mise activate zsh)"
elif [[ -x $XDG_DATA_HOME/mise/bin/mise ]]; then
  path=("$XDG_DATA_HOME/mise/bin" $path)
  eval "$(mise activate zsh)"
fi
