return {
    "Olical/conjure",
    ft = { "clojure", "fennel", "hy", "racket", "python" },
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
        vim.g["conjure#debug"] = true
    end,
}
