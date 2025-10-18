# Aliases
# -------

alias zshedit="vim ~/.zshrc"
alias j="just"
alias cat="bat --paging=never"
alias ls="lsd"

# Editor
alias i="idea"
alias vim="nvim"
alias vi="nvim"
alias lg="lazygit"
alias ld="lazydocker"
alias wf="windsurf"
alias cr="cr"

# Elixir
alias mtf="mix test.feature"
alias mtu="mix test.unit"
alias mca="mix check.all"
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

# k8s and infra
alias k="kubectl"
alias kns="kubens"
alias kcd="kubectx"
alias kns="kubens"
alias tf="terraform"

# LLMs and MCPs
alias claude-dev="NODE_TLS_REJECT_UNAUTHORIZED=0 claude"