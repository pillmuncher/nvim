return {
    {
        "Olical/conjure",
        dependencies = {
            { "guns/vim-sexp" },
            { "tpope/vim-sexp-mappings-for-regular-people" },
            { "tpope/vim-repeat" },
            { "PaterJason/cmp-conjure" },
        },
        init = function()
            local log_dir = vim.fn.stdpath("state") .. "/conjure"
            vim.fn.mkdir(log_dir, "p")
            vim.g["conjure#log#file_name"] = ".conjure-%d.log"
            vim.g["conjure#log#path"] = log_dir
            vim.g["conjure#filetypes"] = { "clojure", "fennel", "hy" } -- exclude python
        end,
    },
}
