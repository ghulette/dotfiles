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

Make sure that config files AND DIRECTORIES don't already exist. Stow will fail if it tries to link to existing files but if it finds existing dirs it will just link files in those dirs instead of linking. This will create problems, e.g., if you create a new file in `.config` then it will not show up in `.dotfiles` and you will be confused.

You can use `stow -nv [cmd]` to test run and see what will be linked.

Don't forget to update using `stow [cmdname]` in the `.dotfiles` directory, e.g., after `git pull`.

If you want to remove symlinks use `stow -D [cmdname]`.
