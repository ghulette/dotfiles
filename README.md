dotfiles
========

Use [chezmoi](https://www.chezmoi.io) to install.

On a new machine: `chezmoi init git@github.com:ghulette/dotfiles.git` (if you are me).

You also need to create a config file with machine-specific settings:

```
# ~/.config/chezmoi/chezmoi.toml
[data]
    email = "me@home.org"
```
