# AstroNvim Customizations

## 1. Colorscheme: Catppuccin Frappé

In `astroui.lua`, set the colorscheme:
```lua
colorscheme = "catppuccin-frappe",
```

Also add a `catppuccin.lua` plugin file with dim inactive windows:
```lua
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      dim_inactive = { enabled = true, percentage = 0.25 },
    },
  },
}
```

## 2. Enable word wrap

In `astrocore.lua`, under `options.opt`:
```lua
wrap = true,
```

## 3. Disable format on save

In `astrolsp.lua`, under `formatting.format_on_save`:
```lua
enabled = false,
```

## 4. Disable auto-show autocomplete

In `blink.lua`:
```lua
opts = {
  completion = {
    menu = {
      auto_show = false,
      auto_show_delay_ms = 500,
    },
    documentation = {
      auto_show = false,
      auto_show_delay_ms = 500,
    },
  },
}
```

## 5. Lean language support

Add a `lean.lua` plugin file:
```lua
return {
  'Julian/lean.nvim',
  event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  opts = {
    mappings = true,
  }
}
```

## 6. Activate template files

Remove the guard line from `astrocore.lua`, `astrolsp.lua`, and `astroui.lua`:
```lua
if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE
```
