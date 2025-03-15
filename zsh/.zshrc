# https://github.com/ohmyzsh/ohmyzsh/wiki/themes
ZSH_THEME="afowler"

plugins=(git asdf)

# load ohmyzsh
source "$HOME/.oh-my-zsh/oh-my-zsh.sh"

# z
. /opt/homebrew/etc/profile.d/z.sh

# nvm
export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# direnv
eval "$(direnv hook zsh)"

# load externals
source ~/.alias.sh
source ~/.secrets.sh

# Paths
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="$HOME/.asdf/shims:$PATH"
export PATH="/usr/local/opt/rustup/bin:$PATH"
## go
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN
## asdf
. /opt/homebrew/opt/asdf/libexec/asdf.sh

