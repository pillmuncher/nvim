-- vim.keymap.set = function(...) end
-- vim.api.nvim_set_keymap = function(...) end

-- we don't want to think about two different leader keys:
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- prevent Python plugins from using a current virtualenv:
vim.g.python3_host_prog = '/usr/bin/python3'

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
require('lazy').setup('plugins')
require('utils')
require('settings.settings')
require('settings.options')
require('settings.mappings')
