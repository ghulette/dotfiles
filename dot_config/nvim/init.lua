-- Minimal nvim config: VS Code Dark+ theme, Telescope, treesitter
-- highlighting, and which-key hints. No LSP, no completion.

vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Options (mostly AstroNvim's defaults, plus my overrides)
local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.wrap = true
opt.linebreak = true -- wrap at word boundaries
opt.breakindent = true -- wrapped lines keep their indent
opt.spell = false
opt.cursorline = true
opt.clipboard = "unnamedplus" -- system clipboard
opt.mouse = "a"
opt.ignorecase = true
opt.smartcase = true
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 0 -- follow tabstop
opt.shiftround = true
opt.copyindent = true
opt.preserveindent = true
opt.splitbelow = true
opt.splitright = true
opt.undofile = true
opt.confirm = true -- ask to save instead of failing on :q
opt.virtualedit = "block"
opt.laststatus = 3 -- one statusline for all windows
opt.title = true
opt.timeoutlen = 500
opt.updatetime = 300
opt.winborder = "rounded"
opt.fillchars = { eob = " " }
opt.shortmess:append { s = true, I = true }
opt.writebackup = false

-- Keymaps (the AstroNvim ones I use)
local map = vim.keymap.set
-- Move by screen line on wrapped lines, unless given a count
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Move cursor down" })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Move cursor up" })
map("n", "zz", "zt2<C-y>", { desc = "Cursor near top (2 lines above)" })
map("n", "<Leader>w", "<Cmd>w<CR>", { desc = "Save" })
map("n", "<Leader>q", "<Cmd>confirm q<CR>", { desc = "Quit window" })
map("n", "<Leader>Q", "<Cmd>confirm qall<CR>", { desc = "Quit nvim" })
map("n", "<Leader>n", "<Cmd>enew<CR>", { desc = "New file" })
map("n", "<Leader>c", "<Cmd>confirm bdelete<CR>", { desc = "Close buffer" })
map("n", "|", "<Cmd>vsplit<CR>", { desc = "Vertical split" })
map("n", "\\", "<Cmd>split<CR>", { desc = "Horizontal split" })
map("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to below split" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to above split" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })
map("n", "<Leader>/", "gcc", { remap = true, desc = "Toggle comment" })
map("x", "<Leader>/", "gc", { remap = true, desc = "Toggle comment" })
-- ]b / [b (next/previous buffer) are built into nvim 0.11+

-- Plugins, via lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", "https://github.com/folke/lazy.nvim.git", lazypath }
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("vscode").setup { style = "dark" } -- VS Code Dark+
      vim.cmd.colorscheme "vscode"
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      { "<Leader>ff", "<Cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<Leader>fF", "<Cmd>Telescope find_files hidden=true no_ignore=true<CR>", desc = "Find all files" },
      { "<Leader>fw", "<Cmd>Telescope live_grep<CR>", desc = "Find words" },
      { "<Leader>fb", "<Cmd>Telescope buffers<CR>", desc = "Find buffers" },
      { "<Leader>fo", "<Cmd>Telescope oldfiles<CR>", desc = "Find old files" },
      { "<Leader>fh", "<Cmd>Telescope help_tags<CR>", desc = "Find help" },
      { "<Leader>fk", "<Cmd>Telescope keymaps<CR>", desc = "Find keymaps" },
      { "<Leader>fr", "<Cmd>Telescope resume<CR>", desc = "Resume last search" },
    },
    opts = {},
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      -- Parsers build with the tree-sitter CLI (cargo-installed on each machine)
      local ts = require "nvim-treesitter"
      ts.install {
        "bash", "java", "json", "lua", "markdown", "markdown_inline",
        "python", "rust", "toml", "vimdoc", "yaml",
      }
      -- Highlight each buffer with treesitter. If its language has no parser
      -- yet but nvim-treesitter supports it, build one first (in the
      -- background; the buffer uses regex highlighting until it's ready).
      local available
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(args.match)
          if not lang then return end
          if vim.treesitter.language.add(lang) then
            vim.treesitter.start(args.buf, lang)
            return
          end
          available = available or ts.get_available()
          if not vim.list_contains(available, lang) then return end
          ts.install(lang):await(vim.schedule_wrap(function(err)
            if not err and vim.api.nvim_buf_is_valid(args.buf) then
              pcall(vim.treesitter.start, args.buf, lang)
            end
          end))
        end,
      })
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = { { "<Leader>f", group = "Find" } },
    },
  },
}, {
  install = { colorscheme = { "vscode", "habamax" } },
  rocks = { enabled = false },
})
