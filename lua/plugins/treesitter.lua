return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        { "nvim-treesitter/nvim-treesitter-textobjects" },
    },
    build = ":TSUpdate",
    -- Load treesitter when a buffer is read or a new file is created
    event = { "BufReadPost", "BufNewFile" },
    -- Load even earlier if we are about to write a file (e.g., via a script)
    cmd = { "TSUpdate", "TSInstall" },
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "bash",
                "c",
                "clojure",
                "c_sharp",
                "fennel",
                "lua",
                "markdown",
                "python",
                "vim",
                "vimdoc",
            },
            auto_install = false,
            fold = { enable = true },
            highlight = { enable = true },
            indent = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "gss",
                    node_incremental = "gsn",
                    scope_incremental = "gsc",
                    node_decremental = "gsd",
                },
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    selection_modes = {
                        ["@function.outer"] = "V",
                        ["@function.inner"] = "V",
                    },
                    keymaps = {
                        ["aa"] = "@parameter.outer",
                        ["ia"] = "@parameter.inner",
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                    },
                },
                swap = {
                    enable = true,
                    swap_next = { ["<leader>a"] = "@parameter.inner" },
                    swap_previous = { ["<leader>A"] = "@parameter.inner" },
                },
            },
            modules = {},
            ignore_install = {},
            sync_install = false,
        })
    end,
}
