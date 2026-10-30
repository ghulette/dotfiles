#!/bin/sh
# Install the tree-sitter CLI, which nvim-treesitter (main branch) needs to
# compile parsers. Without it, nvim reports "ENOENT ... 'tree-sitter'" on
# startup for every parser it tries to build.

set -eu

if command -v tree-sitter >/dev/null 2>&1 || [ -x "$HOME/.cargo/bin/tree-sitter" ]; then
    exit 0
fi

cargo="$HOME/.cargo/bin/cargo"
if [ ! -x "$cargo" ]; then
    cargo=$(command -v cargo 2>/dev/null) || {
        echo "cargo not found — skipping tree-sitter CLI install" >&2
        exit 0
    }
fi

"$cargo" install --locked tree-sitter-cli
