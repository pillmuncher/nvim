return {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
        -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
        -- Automatically install LSPs to stdpath for neovim
        { 'williamboman/mason.nvim',           opts = {} },
        { 'williamboman/mason-lspconfig.nvim', opts = {} },
        -- Useful status updates for LSP
        { 'j-hui/fidget.nvim',                 tag = 'legacy', opts = {} },
        -- Additional lua configuration, makes nvim stuff amazing!
        { 'folke/neodev.nvim',                 opts = {} },
    },
    opts = {
        on_attach = function(client, bufnr)
            if client.server_capabilities['documentSymbolProvider'] then
                require('nvim-navic').attach(client, bufnr)
            end
        end,
    },
    config = function()
        -- Switch for controlling whether you want autoformatting.
        --  Use :KickstartFormatToggle to toggle autoformatting on or off
        local format_is_enabled = true
        vim.api.nvim_create_user_command('KickstartFormatToggle', function()
            format_is_enabled = not format_is_enabled
            print('Setting autoformatting to: ' .. tostring(format_is_enabled))
        end, {})

        -- Create an augroup that is used for managing our formatting autocmds.
        --      We need one augroup per client to make sure that multiple clients
        --      can attach to the same buffer without interfering with each other.
        local _augroups = {}
        local get_augroup = function(client)
            if not _augroups[client.id] then
                local group_name = 'kickstart-lsp-format-' .. client.name
                local id = vim.api.nvim_create_augroup(group_name, { clear = true })
                _augroups[client.id] = id
            end

            return _augroups[client.id]
        end

        -- Whenever an LSP attaches to a buffer, we will run this function.
        --
        -- See `:help LspAttach` for more information about this autocmd event.
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-attach-format', { clear = true }),
            -- This is where we attach the autoformatting for reasonable clients
            callback = function(args)
                local client_id = args.data.client_id
                local client = vim.lsp.get_client_by_id(client_id)
                local bufnr = args.buf

                -- Only attach to clients that support document formatting
                if not client.server_capabilities.documentFormattingProvider then
                    return
                end

                -- Tsserver usually works poorly. Sorry you work with bad languages
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

                        vim.lsp.buf.format {
                            async = false,
                            filter = function(c)
                                return c.id == client.id
                            end,
                        }
                    end,
                })
            end,
        })
    end,
    keys = {
        {
            'gD',
            function()
                vim.lsp.buf.declaration()
            end,
            desc = 'LSP declaration',
            mode = { 'n' }
        },
        {
            'gd',
            function()
                vim.lsp.buf.definition()
            end,
            desc = '[G]oto [D]efinition',
            mode = { 'n' }
        },
        {
            'gi',
            function()
                vim.lsp.buf.implementation()
            end,
            desc = 'LSP implementation',
            mode = { 'n' }
        },
        {
            'gr',
            function()
                vim.lsp.buf.references()
            end,
            desc = 'LSP references',
            mode = { 'n' }
        },
        {
            'K',
            function()
                vim.lsp.buf.hover()
            end,
            desc = 'LSP hover',
            mode = { 'n' }
        },
        {
            '<leader>ca',
            function()
                vim.lsp.buf.code_action()
            end,
            desc = 'LSP code action',
            mode = { 'n' }
        },
        {
            '<leader>gt',
            function()
                vim.lsp.buf.type_definition()
            end,
            desc = '[G]oto Type',
            mode = { 'n' }
        },
        {
            '<leader>lf',
            function()
                vim.lsp.buf.format { async = true }
            end,
            desc = '[L]SP [F]ormat',
            mode = { 'n' }
        },
        {
            '<leader>ls',
            function()
                vim.lsp.buf.signature_help()
            end,
            desc = '[L]SP [S]ignature',
            mode = { 'n' }
        },
        {
            '<leader>wa',
            function()
                vim.lsp.buf.add_workspace_folder()
            end,
            desc = 'New workspace folder',
            mode = { 'n' }
        },
        {
            '<leader>wl',
            function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end,
            desc = 'Show workspace folders',
            mode = { 'n' }
        },
        {
            '<leader>wr',
            function()
                vim.lsp.buf.remove_workspace_folder()
            end,
            desc = 'Delete workspace folders',
            mode = { 'n' }
        },
    },
}
