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
    config = function()
        -- Fix "position_encoding param" error message
        -- for telescope.builtin.lsp_document_symbols:
        local notify_original = vim.notify
        vim.notify = function(msg, ...)
            if
                msg
                and (
                    msg:match 'position_encoding param is required'
                    or msg:match 'Defaulting to position encoding of the first client'
                    or msg:match 'multiple different client offset_encodings'
                )
            then
                return
            end
            return notify_original(msg, ...)
        end

        -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
        local capabilities = require('cmp_nvim_lsp').default_capabilities(
            vim.lsp.protocol.make_client_capabilities()
        )

        -- Common on_attach function
        local on_attach = function(client, bufnr)
            if client.server_capabilities['documentSymbolProvider'] then
                require('nvim-navic').attach(client, bufnr)
            end
            require("settings.mappings").setup_lsp(bufnr)
        end

        vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics, {
                virtual_text = true, -- ensure this is true to show inline diagnostics
                signs = true,        -- ensure this is true to show gutter signs
                update_in_insert = false,
            }
        )
        -- Define the LSP servers to set up
        local servers = {
            clangd = {},
            omnisharp = { filetypes = { 'cs' } },
            html = { filetypes = { 'html', 'twig', 'hbs' } },
            lua_ls = {
                Lua = {
                    workspace = { checkThirdParty = false },
                    telemetry = { enable = false },
                    diagnostics = { globals = { 'vim' } }
                },
            },
            pylsp = {
                settings = {
                    pylsp = {
                        plugins = {
                            black = { enabled = true },
                            pylsp_mypy = {
                                enabled = true,
                                live_mode = true,
                                strict = true,
                                overrides = {
                                    "--explicit-package-bases",
                                    "--check-untyped-defs",
                                    "--namespace-packages",
                                    ".",
                                }
                            },
                            rope = { enabled = true },
                            rope_autoimport = { enabled = true },
                            rope_completion = { enabled = true },
                            rope_refactor = { enabled = true },
                            pycodestyle = { enabled = false },
                            pyflakes = { enabled = false },
                            flake8 = { enabled = false },
                        },
                        diagnostics = {
                            enable = true,                                -- make sure diagnostics are enabled
                            types = {
                                'error', 'warning', 'information', 'hint' -- this ensures all types are shown
                            },
                        },
                    },
                }
            }
        }

        -- Set up Mason with the LSP servers
        local mason_lspconfig = require('mason-lspconfig')
        mason_lspconfig.setup({
            ensure_installed = vim.tbl_keys(servers),
            automatic_installation = true,
        })

        mason_lspconfig.setup_handlers({
            function(server_name)
                local server_config = servers[server_name] or {}
                local config = vim.tbl_deep_extend("force", {
                    capabilities = capabilities,
                    on_attach = on_attach,
                }, server_config)

                require('lspconfig')[server_name].setup(config)
            end,
        })
    end
}
