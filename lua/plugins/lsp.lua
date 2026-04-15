return {
    -- Lua dev environment
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
        },
    },
    { "Bilal2453/luvit-meta", lazy = true },

    -- LSP UI Component
    { "SmiteshP/nvim-navic", lazy = true },

    -- Mason: server installation only
    {
        "williamboman/mason.nvim",
        opts = {
            ui = {
                border = "rounded",
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        },
    },

    { "WhoIsSethDaniel/mason-tool-installer.nvim" },

    -- LSP Config & Initialization
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "SmiteshP/nvim-navic",
        },
        opts = {
            ensure_installed = { "pyright", "ruff", "clangd", "html", "lua_ls", "omnisharp" },
            automatic_installation = true,
            automatic_enable = false,
        },
        config = function(_, opts)
            require("mason-lspconfig").setup(opts)
            vim.lsp.enable(opts.ensure_installed)
            require("mason-tool-installer").setup({
                ensure_installed = {
                    { "clj-kondo" },
                    { "cljfmt" },
                    { "csharpier" },
                    { "isort" },
                    { "prettier" },
                    { "prettierd" },
                    { "proselint" },
                    { "stylua" },
                },

                -- if set to true this will check each tool for updates. If updates
                -- are available the tool will be updated. This setting does not
                -- affect :MasonToolsUpdate or :MasonToolsInstall.
                -- Default: false
                auto_update = true,

                -- automatically install / update on startup. If set to false nothing
                -- will happen on startup. You can use :MasonToolsInstall or
                -- :MasonToolsUpdate to install tools and check for updates.
                -- Default: true
                run_on_start = true,

                -- set a delay (in ms) before the installation starts. This is only
                -- effective if run_on_start is set to true.
                -- e.g.: 5000 = 5 second delay, 10000 = 10 second delay, etc...
                -- Default: 0
                start_delay = 3000, -- 3 second delay

                -- Only attempt to install if 'debounce_hours' number of hours has
                -- elapsed since the last time Neovim was started. This stores a
                -- timestamp in a file named stdpath('data')/mason-tool-installer-debounce.
                -- This is only relevant when you are using 'run_on_start'. It has no
                -- effect when running manually via ':MasonToolsInstall' etc....
                -- Default: nil
                debounce_hours = 5, -- at least 5 hours between attempts to install/update

                -- By default all integrations are enabled. If you turn on an integration
                -- and you have the required module(s) installed this means you can use
                -- alternative names, supplied by the modules, for the thing that you want
                -- to install. If you turn off the integration (by setting it to false) you
                -- cannot use these alternative names. It also suppresses loading of those
                -- module(s) (assuming any are installed) which is sometimes wanted when
                -- doing lazy loading.
                integrations = {
                    ["mason-lspconfig"] = true,
                    ["mason-null-ls"] = false,
                    ["mason-nvim-dap"] = false,
                },
            })
        end,
    },

    -- Formatter
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "isort", "ruff" },
                javascript = { "prettierd", "prettier", stop_after_first = true },
            },
            formatters = {
                ruff = { command = "ruff", args = { "format", "-" }, stdin = true },
            },
            format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
        },
    },

    -- Completion
    {
        "hrsh7th/nvim-cmp",
        lazy = false,
        dependencies = {
            { "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "rafamadriz/friendly-snippets" },
            { "saadparwaiz1/cmp_luasnip" },
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                sources = cmp.config.sources({
                    { name = "lazydev", group_index = 0 },
                    { name = "nvim_lsp" },
                    { name = "nvim_lsp_signature_help" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                    { name = "spell" },
                }),
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete({}),
                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }),
                    ["<Down>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<Up>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
            })
        end,
    },
}
