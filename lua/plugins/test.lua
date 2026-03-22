return {
    -- Test runner
    {
        "nvim-neotest/neotest",
        dependencies = {
            "Issafalcon/neotest-dotnet",
            "nvim-neotest/neotest-python",
            "nvim-neotest/neotest-vim-test",
            "nvim-neotest/nvim-nio",
            "rcasia/neotest-bash",
            "vim-test/vim-test",
        },
        opts = function()
            return {
                adapters = {
                    require("neotest-python")({ verbose = true, runner = "pytest" }),
                    require("neotest-dotnet"),
                    require("neotest-bash"),
                    require("neotest-vim-test")({
                        ignore_file_types = { "python", "vim", "lua" },
                    }),
                },
                quickfix = { enabled = true, open = false },
                output = { enabled = true, open_on_run = true },
                diagnostic = { enabled = true },
                signs = { enabled = true, priority = 40 },
            }
        end,
    },

    -- Coverage display
    {
        "andythigpen/nvim-coverage",
        version = "*",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            auto_reload = true,
            commands = true,
            highlights = {
                covered = { fg = "#C3E88D" },
                uncovered = { fg = "#F07178" },
            },
            signs = {
                covered = { hl = "CoverageCovered", text = "▎" },
                uncovered = { hl = "CoverageUncovered", text = "▎" },
            },
            summary = { min_coverage = 80.0 },
        },
    },
}
