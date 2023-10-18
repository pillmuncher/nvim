-- be more concise:
map = vim.keymap.set
cmd = vim.cmd
opt = vim.opt

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
opt.rtp:prepend(lazypath)

-- load the config:
require('lazy').setup('plugins')
require('settings.plugins')
require('settings.autocmds')
require('settings.options')
require('settings.mappings')

-- make it look pretty:
cmd.colorscheme('mellifluous')
