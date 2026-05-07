return {
  'MeanderingProgrammer/render-markdown.nvim',
  enabled = false,
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  ft = { 'markdown' },
  opts = {
    render_modes = { 'n', 'c', 't' },
    anti_conceal = { enabled = false },
  },
}
