vim.g["conjure#filetypes"] = {
    "clojure",
    "fennel",
    "hy",
    "racket"
}
vim.g["conjure#mapping#doc_word"] = false
return {
    "Olical/conjure",
    dependencies = {
        { "Olical/nfnl",           ft = "fennel" },
        { "Olical/aniseed" },
        { "PaterJason/cmp-conjure" },
    },
    config = function()
        require("conjure.main").main()
        require("conjure.mapping")["on-filetype"]()
    end,
    init = function()
        vim.g["conjure#debug"] = false
    end,
}
