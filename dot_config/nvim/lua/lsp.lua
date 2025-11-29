require('mason').setup{}
require('mason-lspconfig').setup({
    -- A list of servers to automatically install if they're not already installed
    ensure_installed = { 'lua_ls' },
    automatic_installation = true
})

-- Customized on_attach function.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions.
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer.
local on_attach = function(client, bufnr)
    if client.name == "rust_analyzer" then
        -- WARNING: This feature requires Neovim 0.10 or later.
        vim.lsp.inlay_hint.enable()
    end

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, bufopts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
    vim.keymap.set("n", "<space>f", function()
        vim.lsp.buf.format({
            async = true,
            -- Predicate used to filter clients. Receives a client as
            -- argument and must return a boolean. Clients matching the
            -- predicate are included.
            filter = function(client)
                -- NOTE: If an LSP contains a formatter, we don't need to use null-ls at all.
                return client.name == "null-ls" or client.name == "hls"
            end,
        })
    end, bufopts)
end

-- Configure LSP servers using the new vim.lsp.config API
vim.lsp.config('lua_ls', {
    cmd = { 'lua-language-server' },
    root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
    on_attach = on_attach,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim).
                version = "LuaJIT",
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global.
                globals = { "vim" },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files.
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier.
            telemetry = {
                enable = false,
            },
        },
    },
})

vim.lsp.config('racket_langserver', {
    cmd = { 'racket-langserver' },
    root_markers = { 'info.rkt' },
    on_attach = on_attach,
})

vim.lsp.config('rust_analyzer', {
    cmd = { 'rust-analyzer' },
    root_markers = { 'Cargo.toml', 'rust-project.json' },
    on_attach = on_attach,
})

vim.lsp.config('pylsp', {
    cmd = { 'pylsp' },
    root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', '.git' },
    on_attach = on_attach,
})

-- Enable the configured LSP servers
vim.lsp.enable({ 'lua_ls', 'racket_langserver', 'rust_analyzer', 'pylsp'})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
cmp.setup({
    sources = {
        { name = 'vsnip' },
        { name = 'path' },
        { name = 'nvim_lsp' },
        { name = 'buffer',  keyword_length = 3 },
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        --['<C-Space>'] = cmp.mapping.complete(),
    }),
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
})
