return {
    'neovim/nvim-lspconfig',
    lazy         = false,
    dependencies = {
        { 'SmiteshP/nvim-navic',               opts = {}, },
        { 'folke/neodev.nvim',                 opts = {} },
        { 'j-hui/fidget.nvim',                 opts = {}, tag = 'legacy' },
        { 'williamboman/mason-lspconfig.nvim', opts = {}, dependencies = 'williamboman/mason.nvim', },
        { 'williamboman/mason.nvim',           opts = {} },
    },
    opts         = {
        on_attach = function(client, bufnr)
            if client.server_capabilities['documentSymbolProvider'] then
                require('nvim-navic').attach(client, bufnr)
            end
        end,
    },
    keys         = {
        {
            '<leader>jD',
            function()
                vim.lsp.buf.declaration()
            end,
            desc = 'Jump to Declaration',
            mode = 'n'
        },
        {
            '<leader>jd',
            function()
                vim.lsp.buf.definition()
            end,
            desc = 'Jump to Definition',
            mode = 'n'
        },
        {
            '<leader>ji',
            function()
                vim.lsp.buf.implementation()
            end,
            desc = 'Jump to Implementation',
            mode = 'n'
        },
        {
            '<leader>or',
            function()
                vim.lsp.buf.references()
            end,
            desc = 'Open References',
            mode = 'n'
        },
        {
            '<leader>sd',
            function()
                vim.lsp.buf.hover()
            end,
            desc = 'Show Documentation',
            mode = 'n'
        },
        {
            '<leader>ca',
            function()
                vim.lsp.buf.code_action()
            end,
            desc = 'Code Action',
            mode = 'n'
        },
        {
            '<leader>jt',
            function()
                vim.lsp.buf.type_definition()
            end,
            desc = 'Jump to Type',
            mode = 'n'
        },
        {
            '<leader>cf',
            function()
                vim.lsp.buf.format { async = true }
            end,
            desc = 'Code Format',
            mode = 'n'
        },
        {
            '<leader>ss',
            function()
                vim.lsp.buf.signature_help()
            end,
            desc = 'Show Signature',
            mode = 'n'
        },
        {
            '<leader>wa',
            function()
                vim.lsp.buf.add_workspace_folder()
            end,
            desc = 'New Workspace Folder',
            mode = 'n'
        },
        {
            '<leader>sw',
            function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end,
            desc = 'Show Workspace Folders',
            mode = 'n'
        },
        {
            '<leader>wr',
            function()
                vim.lsp.buf.remove_workspace_folder()
            end,
            desc = 'Delete Workspace Folders',
            mode = 'n'
        },
        {
            '<leader>fw',
            function()
                require('telescope.builtin').lsp_dynamic_workspace_symbols()
            end,
            desc = 'Find Workspace Symbols',
            mode = 'n'
        },
        {
            '<leader>fd',
            function()
                require('telescope.builtin').lsp_document_symbols({ show_line = true })
            end,
            desc = 'Find Document Symbols',
            mode = 'n'
        },
    },
    config       = function()
        local servers = {
            -- add LSP servers here:
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
    end,
}
