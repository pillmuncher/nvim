return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            dapui.setup()
            require("nvim-dap-virtual-text").setup({})

            -- Auto open/close UI
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            -- Keymaps
            vim.keymap.set("n", "<F5>", dap.continue)
            vim.keymap.set("n", "<F10>", dap.step_over)
            vim.keymap.set("n", "<F11>", dap.step_into)
            vim.keymap.set("n", "<F12>", dap.step_out)
            vim.keymap.set("n", "<Leader>b", dap.toggle_breakpoint)
            vim.keymap.set("n", "<Leader>B", function()
                dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end)

            dap.adapters.python = {
                type = "executable",
                command = "python",
                args = { "-m", "debugpy.adapter" },
            }
            dap.configurations.python = {
                {
                    name = "Run module",
                    type = "python",
                    request = "launch",
                    program = "${file}",
                    cwd = vim.fn.getcwd(),
                    stopOnEntry = true,
                },

                {
                    name = "Run project",
                    type = "python",
                    request = "launch",
                    module = function()
                        local file = vim.fn.expand("%:p:r")
                        local root = vim.fs.root(0, { "pyproject.toml", ".git", "setup.py" }) or vim.fn.getcwd()
                        return (file:gsub("^" .. root .. "/", "")):gsub("/", ".")
                    end,
                    cwd = vim.fn.getcwd(),
                    stopOnEntry = true,
                },
            }

            dap.adapters.coreclr = {
                type = "executable",
                command = "netcoredbg",
                args = { "--interpreter=vscode" },
            }

            dap.configurations.cs = {
                {
                    type = "coreclr",
                    request = "launch",
                    name = "Launch .NET",

                    program = function()
                        return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
                    end,

                    cwd = "${workspaceFolder}",
                    stopAtEntry = true,
                },
            }

            dap.adapters.lldb = {
                type = "executable",
                command = "lldb-vscode", -- or "lldb-dap" depending on system
                name = "lldb",
            }

            dap.configurations.c = {
                {
                    name = "Launch",
                    type = "lldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                },
            }

            dap.configurations.cpp = dap.configurations.c
        end,
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "mason.nvim", "mfussenegger/nvim-dap" },
        config = function()
            require("mason-nvim-dap").setup({
                ensure_installed = { "python", "codelldb", "netcoredbg" },
                automatic_installation = true,
            })
        end,
    },
}
