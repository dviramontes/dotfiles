# https://github.com/ohmyzsh/ohmyzsh/wiki/themes
ZSH_THEME="afowler"

plugins=(git asdf)

# load ohmyzsh
source "$HOME/.oh-my-zsh/oh-my-zsh.sh"

ARCH=$(uname -m)

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# direnv
eval "$(direnv hook zsh)"

# load externals
source ~/.alias.sh
source ~/.secrets.sh

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
else
    . /usr/local/opt/asdf/libexec/asdf.sh
fi

# z
if [[ "$ARCH" == "arm64" ]]; then
    . /opt/homebrew/etc/profile.d/z.sh
else
    . /usr/local/etc/profile.d/z.sh
fi

# nvm
if [[ "$ARCH" == "arm64" ]]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
    [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
else
    export NVM_DIR="$HOME/.nvm"
    [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"
    [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
fi

# bun
export PATH="$HOME/.bun/bin:$PATH"

# Added by Windsurf - Next
export PATH="$HOME/.codeium/windsurf/bin:$PATH"

# add UV to path
export PATH="$HOME/.local/bin:$PATH"
