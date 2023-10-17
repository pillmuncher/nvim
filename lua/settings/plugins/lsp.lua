-- add LSP servers here:
local servers = {
    clangd = {},
    clojure_lsp = { filetypes = { 'clj', 'cljs' } },
    omnisharp = { filetypes = { 'cs' } },
    html = { filetypes = { 'html', 'twig', 'hbs' } },
    ruff_lsp = { filetypes = { 'py' } },
    lua_ls = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    },
}

local mason_lspconfig = require('mason-lspconfig')

mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
    function(server_name)
        require('lspconfig')[server_name].setup {
            -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
            capabilities = require('cmp_nvim_lsp').default_capabilities(
                vim.lsp.protocol.make_client_capabilities()
            ),
            -- Create a command `:Format` local to the LSP buffer
            on_attach = function(_, bufnr)
                vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
                    vim.lsp.buf.format()
                end, { desc = 'Format current buffer with LSP' })
            end,
            settings = servers[server_name],
            filetypes = (servers[server_name] or {}).filetypes,
        }
    end,
}
