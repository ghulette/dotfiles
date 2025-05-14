return {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
        require("bufferline").setup {
            options = {
                -- numbers = function(opts)
                --     return string.format('%s', opts.raise(opts.id))
                -- end,
                separator_style = "slant",
                diagnostics = "nvim_lsp",
                always_show_bufferline = false,
                auto_toggle_bufferline = true,
            }
        }
    end

}
