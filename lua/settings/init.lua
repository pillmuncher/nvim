-- vim.keymap.set = function(...) end
-- vim.api.nvim_set_keymap = function(...) end

-- we don't want to think about two different leader keys:
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- prevent Python plugins from using a currently active virtualenv:
vim.g.python3_host_prog = '/usr/bin/python'

-- bootstrap lazy.nvim:
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

-- load the config:
require('utils')
require('lazy').setup('plugins')
require('settings.plugins')
require('settings.autocmds')
require('settings.options')
require('settings.mappings')

vim.cmd.colorscheme('mellifluous')

-- require("dap-python").setup('/home/mick/.local/share/virtualenvs/yogic-W4rLkTWj/bin/python')
--
-- table.insert(require("dap").configurations.python, {
--     type = "python",
--     request = "launch",
--     name = "Module",
--     console = "integratedTerminal",
--     module = "example.example",
--     cwd = "${workspaceFolder}",
--     command = '/home/mick/.local/share/virtualenvs/yogic-W4rLkTWj/bin/python',
-- })
--
-- local dap = require("dap")
--
-- -- Create a new configuration for Python debugging
-- dap.adapters.python = {
--     type = 'executable',
--     command = vim.g.python3_host_prog, -- Use the Python interpreter specified in the Python provider
--     args = { '-m', 'debugpy.adapter' },
-- }
--
-- dap.configurations.python = {
--     {
--         type = 'python',
--         request = 'launch',
--         name = 'Launch file',
--         program = "${file}",
--         pythonPath = function()
--             return vim.g.python3_host_prog -- Use the Python interpreter specified in the Python provider
--         end,
--     },
-- }
--
-- local dap_python = require('dap-python')
--
-- dap_python.setup(vim.g.python3_host_prog) -- Use the Python interpreter specified in the Python provider
