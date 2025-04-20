-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = require('cmp_nvim_lsp').default_capabilities(
    vim.lsp.protocol.make_client_capabilities()
)

return {
    'neovim/nvim-lspconfig',
    lazy = false,
    dependencies = {
        { 'SmiteshP/nvim-navic' },
        { 'folke/lazydev.nvim' },
        { 'folke/which-key.nvim' },
        { 'j-hui/fidget.nvim',                 tag = 'legacy' },
        { 'williamboman/mason-lspconfig.nvim', dependencies = 'williamboman/mason.nvim' },
        { 'williamboman/mason.nvim',           opts = {} },
    },
    on_attach = function(client, bufnr)
        if client.server_capabilities['documentSymbolProvider'] then
            require('nvim-navic').attach(client, bufnr)
        end
        require("settings.mappings").setup_lsp(bufnr)
    end,
    config = function()
        local on_attach = function(client, bufnr)
            if client.server_capabilities['documentSymbolProvider'] then
                require('nvim-navic').attach(client, bufnr)
            end
            require("settings.mappings").setup_lsp(bufnr)
        end

        local servers = {

            pylsp = {},
            clangd = {},
            csharp_ls = { filetypes = { 'cs' } },
            html = { filetypes = { 'html', 'twig', 'hbs' } },
            lua_ls = {
                Lua = {
                    workspace = { checkThirdParty = false },
                    telemetry = { enable = false },
                    diagnostics = { globals = { 'vim' } }
                },
            },
        }

        local mason_lspconfig = require('mason-lspconfig')
        mason_lspconfig.setup({
            ensure_installed = vim.tbl_keys(servers),
            automatic_installation = true,
        })

        mason_lspconfig.setup_handlers({
            function(server_name)
                require('lspconfig')[server_name].setup({
                    capabilities = capabilities,
                    on_attach = on_attach, -- ✅ this is now wired in
                    settings = servers[server_name],
                    filetypes = (servers[server_name] or {}).filetypes,
                })
            end,
        })
    end
}
