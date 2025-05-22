dotfiles
========

Use [chezmoi](https://www.chezmoi.io) to install.

On a new machine: `chezmoi init git@github.com:ghulette/dotfiles.git` (if you are me).

You also need to create a config file `~/.config/chezmoi/chezmoi.toml` with machine-specific settings. On a personal machine this file should contain:

```
[data]
    email = "geoff@hulette.net"
    terminal_font_size = 12
```
