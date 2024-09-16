PROMPT='%1~ %# '

# ---- Eza (better ls) -----
alias ls="eza --color=always --git --no-filesize --icons=always --no-time --no-user --no-permissions"

# ---- Load local configuration, if available ----
# This is for machine-local config
[ -f "$HOME/.zshrc_local" ] && source "$HOME/.zshrc_local"

export PATH=$PATH:$HOME/.toolbox/bin

# Dump into fish
exec fish
