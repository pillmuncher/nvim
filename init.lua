-- we don't want to think about two different leader keys:
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Use a dedicated Neovim venv to avoid conflicts with system or project dependencies.
vim.g.python3_host_prog = "~/.local/state/nvim/venv/bin/python"

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

require("hosts." .. (vim.fn.hostname():match("^[^.]+") or ""))

-- make it look pretty:
vim.cmd.colorscheme("mellifluous")
