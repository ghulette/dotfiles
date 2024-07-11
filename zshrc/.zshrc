PROMPT='%1~ %# '
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# ---- Eza (better ls) -----
alias ls="eza --color=always --git --no-filesize --icons=always --no-time --no-user --no-permissions"

# ---- Load local configuration, if available ----
# This is for machine-local config
[ -f "$HOME/.zshrc_local" ] && source "$HOME/.zshrc_local"
