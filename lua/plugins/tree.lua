-- These must be 
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
        { "nvim-tree/nvim-web-devicons", opts = {} },
    },
    opts = {},
    {
        "<C-e>",
        "<CMD> NvimTreeToggle <CR>", 
        desc = "Toggle nvimtree",
        mode = { "n", "i" } 
    },
    {
        "<leader>e", 
        "<CMD> NvimTreeFocus <CR>", 
        desc = "Focus nvimtree",
        mode = { "n" } 
    },
}
