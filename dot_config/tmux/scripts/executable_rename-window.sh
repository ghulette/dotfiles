#!/usr/bin/env zsh
# Popup window-rename helper for tmux (bound to prefix + ,).
# Pre-fills the current window name with `vared` so it can be edited in place,
# then applies it. Bailing out (empty name / Ctrl-C) leaves the name unchanged.
# Force the emacs keymap: with a vi-based $EDITOR, ZLE starts vared in vi
# insert mode, where backspace won't delete the pre-filled name.
bindkey -e
name=$(tmux display-message -p '#W')
vared -p '❯ ' name || exit 0
[[ -n $name ]] && tmux rename-window -- "$name"
