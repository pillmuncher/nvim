package.loaded["test_state"] = {
    running = false,
    passed = 0,
    failed = 0,
}

return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/neotest-python",
            "Issafalcon/neotest-dotnet",
            "nvim-neotest/nvim-nio",
        },
        opts = function()
            return {
                adapters = {
                    require("neotest-python")({
                        args = { "--cov=." },
                        runner = "pytest",
                        coverage = true,
                    }),
                    require("neotest-dotnet"),
                },
                consumers = {
                    coverage_autoload = function(client)
                        client.listeners.results = function(_, results, partial)
                            if partial then
                                return
                            end
                            local state = require("test_state")
                            local passed, failed = 0, 0
                            for _, r in pairs(results) do
                                if r.status == "passed" then
                                    passed = passed + 1
                                elseif r.status == "failed" then
                                    failed = failed + 1
                                end
                            end
                            state.passed = passed
                            state.failed = failed
                            state.running = false
                            vim.defer_fn(function()
                                local coverage = require("coverage")
                                coverage.load(true)
                                coverage.show()
                            end, 2000)
                        end
                    end,
                },
                output = { enabled = true, open_on_run = false },
                quickfix = { enabled = true },
                diagnostic = { enabled = true },
                signs = { enabled = true },
            }
        end,
    },
    {
        "andythigpen/nvim-coverage",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("coverage").setup({
                auto_reload = true,
                commands = true,
                lang = {
                    python = {
                        coverage_file = vim.fn.getcwd() .. "/.coverage",
                    },
                },
                signs = {
                    covered = { hl = "CoverageCovered", text = "▎" },
                    uncovered = { hl = "CoverageUncovered", text = "▎" },
                },
                highlights = {
                    covered = { fg = "#C3E88D" },
                    uncovered = { fg = "#F07178" },
                },
            })
        end,
    },
}
