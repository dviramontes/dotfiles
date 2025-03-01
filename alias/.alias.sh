# Aliases
# -------

alias zshedit="vim ~/.zshrc"
alias j="just"
alias cat="bat --paging=never"
alias ls="eza"

# Editor
alias vim="nvim"
alias lg="lazygit"
alias ld="lazydocker"
alias wf="windsurf"

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
alias kcd="kubectx"
alias kns="kubens"
