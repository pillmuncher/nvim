return {
    "ThemerCorp/themer.lua",
    config = function()
        require("telescope").load_extension("themes")
        vim.cmd("colorscheme themer_nightlamp")
    end,
    opts = {
        enable_installer = true,
        styles = {
            ["function"]    = { style = 'italic' },
            functionbuiltin = { style = 'italic' },
            variable        = { style = 'italic' },
            variableBuiltIn = { style = 'italic' },
            parameter       = { style = 'italic' },
        },
    }
}
