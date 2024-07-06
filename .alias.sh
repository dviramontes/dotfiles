# Aliases
alias lzd="lazydocker"
alias zshedit="vim ~/.zshrc"
alias kcd="kubectx"
alias kns="kubens"
alias j="just"

# Editor
alias vim="nvim"

# Elixir
alias md="mix dialyzer --plt"
alias mt="mix test"
alias mf="mix format"
alias mdg="mix deps.get"
alias mc="mix credo"
alias mm="mix check"
alias mcc="mix compile --all-warnings"
alias mem="mix ecto.migrate"
alias mer="mix ecto.rollback"
alias phx="iex -S mix phx.server"
alias app_reset="mix ecto.reset && mix seed && phx"

# Misc
alias ll="ls -lh"
alias ..="cd .."

# fzf find
alias zz='idea $(fzf -m --preview="bat --color=always {}")'

# k8s
alias k="kubectl"
alias kns="kubens"
