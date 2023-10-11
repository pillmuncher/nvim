return {
    'akinsho/bufferline.nvim',
    lazy = false,
    version = "*",
    dependencies = {
        { "nvim-tree/nvim-web-devicons", opts = {} },
    },
    opts = {},
    keys = {
        -- cycle through buffers
        { "<C-PageDown>", "<CMD> BufferLineCycleNext <CR>", mode = { "n", "i" } },
        { "<C-PageUp>", "<CMD> BufferLineCyclePrev <CR>", mode = { "n", "i" } },
    },
}
