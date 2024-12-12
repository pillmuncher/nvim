return {
    'neovim/nvim-lspconfig',
    lazy = false,
    dependencies = {
        { 'SmiteshP/nvim-navic' },
        { 'folke/lazydev.nvim' },
        { 'j-hui/fidget.nvim',                 tag = 'legacy' },
        { 'williamboman/mason-lspconfig.nvim', dependencies = 'williamboman/mason.nvim' },
        { 'williamboman/mason.nvim',           opts = {} },
    },
    on_attach = function(client, bufnr)
        if client.server_capabilities['documentSymbolProvider'] then
            require('nvim-navic').attach(client, bufnr)
        end
        -- Add key mappings for LSP functions
        local opts = {
            noremap = true,
            silent = true,
        }
        local buf_set_keymap = vim.api.nvim_buf_set_keymap
        buf_set_keymap(bufnr, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        buf_set_keymap(bufnr, 'n', '<leader>gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
        buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
        buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
        buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
        buf_set_keymap(bufnr, 'n', '<space>wl',
            '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
            opts)
        buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        buf_set_keymap(bufnr, 'n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
        buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
        buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
        buf_set_keymap(bufnr, 'n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
        buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>', opts)
    end,
    config = function()
        local servers = {
            -- add LSP servers here:
            clangd = {},
            clojure_lsp = {
                filetypes = { 'clj', 'cljs' },
                settings = {
                    clojure_lsp = {
                        completion = {
                            snippets = true,
                            locals = true,
                        },
                    },
                },
            },
            omnisharp = { filetypes = { 'cs' } },
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
        })
        mason_lspconfig.setup_handlers({
            function(server_name)
                require('lspconfig')[server_name].setup({
                    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
                    capabilities = require('cmp_nvim_lsp').default_capabilities(
                        vim.lsp.protocol.make_client_capabilities()
                    ),
                    -- Create a command `:Format` local to the LSP buffer
                    on_attach = function(client, bufnr)
                        vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
                            vim.lsp.buf.format()
                        end, { desc = 'Format current buffer with LSP' })
                        -- Use the user-defined on_attach function to set up additional mappings
                        -- require('lspconfig').on_attach(client, bufnr)
                    end,
                    settings = servers[server_name],
                    filetypes = (servers[server_name] or {}).filetypes,
                })
            end,
        })
        -- Shamelessly ripped from Kickstart.nvim:
        --
        -- Switch for controlling whether you want autoformatting.  Use
        -- :AutoFormatToggle to toggle autoformatting on or off
        local format_is_enabled = true
        vim.api.nvim_create_user_command('AutoFormatToggle', function()
            format_is_enabled = not format_is_enabled
            print('Setting autoformatting to: ' .. tostring(format_is_enabled))
        end, {})
        -- Create an augroup that is used for managing our formatting autocmds.
        -- We need one augroup per client to make sure that multiple clients can
        -- attach to the same buffer without interfering with each other.
        local _augroups = {}
        local get_augroup = function(client)
            if not _augroups[client.id] then
                local group_name = 'lsp-autoformat-' .. client.name
                local id = vim.api.nvim_create_augroup(group_name, { clear = true })
                _augroups[client.id] = id
            end
            return _augroups[client.id]
        end
        -- Whenever an LSP attaches to a buffer, we will run this function.
        -- See `:help LspAttach` for more information about this autocmd event.
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('lsp-attach-autoformat', { clear = true }),
            -- This is where we attach the autoformatting for reasonable clients
            callback = function(args)
                local client_id = args.data.client_id
                local client = vim.lsp.get_client_by_id(client_id)
                local bufnr = args.buf
                -- Only attach to clients that support document formatting
                if not client.server_capabilities.documentFormattingProvider then
                    return
                end
                -- tsserver usually works poorly. Sorry you work with bad languages
                -- You can remove this line if you know what you're doing :)
                if client.name == 'tsserver' then
                    return
                end
                -- Create an autocmd that will run *before* we save the buffer.
                -- Run the formatting command for the LSP that has just attached.
                vim.api.nvim_create_autocmd('BufWritePre', {
                    group = get_augroup(client),
                    buffer = bufnr,
                    callback = function()
                        if not format_is_enabled then
                            return
                        end
                        vim.lsp.buf.format({
                            async = false,
                            filter = function(c)
                                return c.id == client.id
                            end,
                        })
                    end,
                })
            end,
        })
    end,
}
