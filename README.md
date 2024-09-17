# README

To set up:

- Install (using package manager): `stow bat eza nvim tmux`

- If .zshrc has any machine-local configuration, move that to `.zshrc_local`.

- Install a terminal theme (I use Nord) and a [Nerd Font](https://www.nerdfonts.com/font-downloads).

- I like Nord theme JetBrains Mono font.

```
$ git clone git@github.com:ghulette/dotfiles.git ~/.dotfiles
$ cd .dotfiles
$ stow nvim  # do this for each command you want to install
$ stow ...
```

Don't forget to update using `stow [cmdname]` in the `.dotfiles` directory, e.g., after `git pull`.

If you want to remove symlinks use `stow -D [cmdname]`.
