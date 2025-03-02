# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git asdf)

source "$ZSH/oh-my-zsh.sh"

# z
. /usr/local/etc/profile.d/z.sh

# nvm
export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# direnv
eval "$(direnv hook zsh)"

source ~/.alias.sh
source ~/.secrets.sh

# zsh
alias zshedit="vim ~/.zshrc"

# Paths
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="$HOME/.asdf/shims:$PATH"
export PATH="/usr/local/opt/rustup/bin:$PATH"
