------------------------------------ CMP ---------------------------------------


local cmp = require('cmp')
local luasnip = require('luasnip')
require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert {
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete {},
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    },
}



------------------------------------ LSP ---------------------------------------


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



--------------------------------- Treesitter -----------------------------------


vim.defer_fn(function()
    require('nvim-treesitter.configs').setup {
        -- Add languages to be installed here that you want installed for treesitter
        ensure_installed = { 'c', 'lua', 'python', 'clojure', 'vimdoc', 'vim' },

        -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
        auto_install = false,

        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = '<C-Space>',
                node_incremental = '<C-Space>',
                scope_incremental = '<C-S>',
                node_decremental = '<M-Space>',
            },
        },
        textobjects = {
            select = {
                enable = true,
                lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                keymaps = {
                    -- You can use the capture groups defined in textobjects.scm
                    ['aa'] = '@parameter.outer',
                    ['ia'] = '@parameter.inner',
                    ['af'] = '@function.outer',
                    ['if'] = '@function.inner',
                    ['ac'] = '@class.outer',
                    ['ic'] = '@class.inner',
                },
            },
            move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_start = {
                    [']m'] = '@function.outer',
                    [']]'] = '@class.outer',
                },
                goto_next_end = {
                    [']M'] = '@function.outer',
                    [']['] = '@class.outer',
                },
                goto_previous_start = {
                    ['[m'] = '@function.outer',
                    ['[['] = '@class.outer',
                },
                goto_previous_end = {
                    ['[M'] = '@function.outer',
                    ['[]'] = '@class.outer',
                },
            },
            swap = {
                enable = true,
                swap_next = {
                    ['<leader>a'] = '@parameter.inner',
                },
                swap_previous = {
                    ['<leader>A'] = '@parameter.inner',
                },
            },
        },
        playground = {
            enable = true,
            disable = {},
            updatetime = 25,         -- Debounced time for highlighting nodes in the playground from source code
            persist_queries = false, -- Whether the query persists across vim sessions
            keybindings = {
                toggle_query_editor = 'o',
                toggle_hl_groups = 'i',
                toggle_injected_languages = 't',
                toggle_anonymous_nodes = 'a',
                toggle_language_display = 'I',
                focus_language = 'f',
                unfocus_language = 'F',
                update = 'R',
                goto_node = '<cr>',
                show_help = '?',
            },
            query_linter = {
                enable = true,
                use_virtual_text = true,
                lint_events = { "BufWrite", "CursorHold" },
            },
        },
    }
end, 0)



------------------------------------ DAP ---------------------------------------


local dap = require('dap')

-- Python:
dap.adapters.python = {
    type = 'executable',
    command = 'python3',
    args = { '-m', 'debugpy.adapter' },
}

dap.configurations.python = {
    {
        type = 'python',
        request = 'launch',
        name = 'Launch file',
        cwd = '.',
        program = '${file}',
    },
}

require('dap-python').setup('python3')

-- C#:
dap.adapters.coreclr = {
    type = 'executable',
    command = '/usr/local/bin/netcoredbg/netcoredbg',
    args = { '--interpreter=vscode' }
}

dap.configurations.cs = {
    {
        type = "coreclr",
        name = "launch - netcoredbg",
        request = "launch",
        program = function()
            return vim.fn.input(
                'Path to dll: ' ..
                vim.fn.getcwd() .. '/bin/Debug/net7.0/' ..
                'file'
            )
        end,
    },
}


----------------------------------- Neodev -------------------------------------


require('neotest').setup {
    adapters = {
        require("neotest-python")
    }
}



----------------------------------- Neodev -------------------------------------


require('neodev').setup({
    library = {
        plugins = { 'nvim-dap-ui', 'neotest' },
        types = true,
    },
})



---------------------------------- Telesope ------------------------------------


-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

--------------------------------- Which-Key ------------------------------------


-- document existing key chains
require('which-key').register {
    ['<leader>c'] = { name = 'Code', _ = 'which_key_ignore' },
    ['<leader>d'] = { name = 'Document', _ = 'which_key_ignore' },
    ['<leader>f'] = { name = 'Find', _ = 'which_key_ignore' },
    ['<leader>g'] = { name = 'Git', _ = 'which_key_ignore' },
    ['<leader>h'] = { name = 'More git', _ = 'which_key_ignore' },
    -- ['<leader>r'] = { name = 'Rename', _ = 'which_key_ignore' },
    ['<leader>j'] = { name = 'Jump', _ = 'which_key_ignore' },
    ['<leader>o'] = { name = 'Open', _ = 'which_key_ignore' },
    ['<leader>s'] = { name = 'Show', _ = 'which_key_ignore' },
    ['<leader>t'] = { name = 'Toggle', _ = 'which_key_ignore' },
    ['<leader>w'] = { name = 'Workspace', _ = 'which_key_ignore' },
}
