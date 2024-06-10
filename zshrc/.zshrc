PROMPT='%1~ %# '
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

# -- Use fd instead of fzf --

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

# ---- Eza (better ls) -----
alias ls="eza --color=always --git --no-filesize --icons=always --no-time --no-user --no-permissions"

# opam configuration
[[ ! -r /Users/geoffhulette/.opam/opam-init/init.zsh ]] || source /Users/geoffhulette/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null
