# README

To set up:

- Install (using package manager): `stow bat eza nvim tmux`

- If .zshrc has any machine-local configuration, move that to `.zshrc_local`.

- Install a terminal theme (I use Nord) and a [Nerd Font](https://www.nerdfonts.com/font-downloads).

- I like Nord theme JetBrains Mono font.

This will set up symlinks:

```
$ git clone git@github.com:ghulette/dotfiles.git ~/.dotfiles
$ cd .dotfiles
$ stow .
```

Don't forget to update using `stow .` in the `.dotfiles` directory after `git pull`.
