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

    -- LSP UI Component
    { "SmiteshP/nvim-navic", lazy = true },

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
            -- 1. Setup mason-lspconfig
            require("mason-lspconfig").setup(opts)

            -- 2. Enable servers natively (Neovim 0.10+)
            -- Note: clojure_lsp is enabled here but not managed by Mason above,
            -- which is perfectly fine if you manage it externally.
            vim.lsp.enable({
                "clangd",
                "clojure_lsp",
                "html",
                "lua_ls",
                "OmniSharp",
                "pyright",
                "ruff",
            })

            -- 3. Setup buffer-local mappings and Navic on attach
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    local bufnr = args.buf

                    if client and client.server_capabilities.documentSymbolProvider then
                        require("nvim-navic").attach(client, bufnr)
                    end

                    require("settings.mappings").setup_lsp(bufnr)
                end,
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
