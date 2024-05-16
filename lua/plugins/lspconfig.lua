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
                vim.lsp.buf.format({ async = true })
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
                    on_attach = function(_, bufnr)
                        vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
                            vim.lsp.buf.format()
                        end, { desc = 'Format current buffer with LSP' })
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
                --  Run the formatting command for the LSP that has just attached.
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
