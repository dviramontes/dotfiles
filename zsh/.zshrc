# Enable profiling - uncomment to profile startup time
# zmodload zsh/zprof

# https://github.com/ohmyzsh/ohmyzsh/wiki/themes
ZSH_THEME="afowler"

plugins=(git asdf)

# Skip compaudit check for faster startup
ZSH_DISABLE_COMPFIX=true

# load ohmyzsh
source "$HOME/.oh-my-zsh/oh-my-zsh.sh"

ARCH=$(uname -m)

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# direnv
eval "$(direnv hook zsh)"

# git visual editor
export EDITOR=nvim
export VISUAL=nvim

# nvim
export VIMCONF=$HOME/.config/nvim
export VIMDATA=$HOME/.local/share/nvim

# load externals
source ~/.alias.sh
source ~/.secrets.sh
source ~/.functions.sh

# paths
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="$HOME/.asdf/shims:$PATH"
export PATH="/usr/local/opt/rustup/bin:$PATH"

## go
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN

# history config
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

## asdf
if [[ "$ARCH" == "arm64" ]]; then
    . /opt/homebrew/opt/asdf/libexec/asdf.sh
    # asdf completions
    fpath=(${ASDF_DIR}/completions $fpath)
    autoload -Uz compinit && compinit
    export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
else
    . /usr/local/opt/asdf/libexec/asdf.sh
fi

# z
if [[ "$ARCH" == "arm64" ]]; then
    . /opt/homebrew/etc/profile.d/z.sh
else
    . /usr/local/etc/profile.d/z.sh
fi

# nvm - lazy loading for faster shell startup
export NVM_DIR="$HOME/.nvm"
# Lazy load nvm - it will be loaded only when you first call 'nvm', 'node', or 'npm'
nvm() {
    unset -f nvm node npm
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    nvm "$@"
}
node() {
    unset -f nvm node npm
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    node "$@"
}
npm() {
    unset -f nvm node npm
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    npm "$@"
}

# bun
export PATH="$HOME/.bun/bin:$PATH"

# bun completions
[ -s "/Users/davm/.bun/_bun" ] && source "/Users/davm/.bun/_bun"

# add UV to path
export PATH="$HOME/.local/bin:$PATH"

# Added by Windsurf
export PATH="/Users/davm/.codeium/windsurf/bin:$PATH"

# escript asdf - lazy approach to avoid slow find on every startup
# Only add if elixir is installed via asdf
if [ -d "${ASDF_DATA_DIR:-$HOME/.asdf}/installs/elixir" ]; then
  for escripts_dir in $(find "${ASDF_DATA_DIR:-$HOME/.asdf}/installs/elixir" -maxdepth 3 -type d -name "escripts" 2>/dev/null); do
    export PATH="$escripts_dir:$PATH"
  done
fi

# Add ZVM to path
export PATH="$HOME/.zvm/bin:$PATH"
