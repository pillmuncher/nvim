-- we don't want to think about two different leader keys:
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- prevent Python plugins from using a currently active virtualenv:
-- Use a dedicated Neovim venv to avoid conflicts with project dependencies.
vim.g.python3_host_prog = "/home/mick/.local/state/nvim/venv/bin/python"

-- bootstrap lazy.nvim:
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- load the plugins:
require("lazy").setup("plugins")

-- configure settings:
require("settings.options")
require("settings.mappings")
require("settings.autocmds")

local hostname = vim.fn.hostname()
local host_config = vim.fn.stdpath("config") .. "/lua/hosts/" .. hostname .. ".lua"
if vim.fn.filereadable(host_config) == 1 then
    require("hosts." .. hostname)
end

-- make it look pretty:
vim.cmd.colorscheme("mellifluous")
