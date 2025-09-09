return {
	"stevearc/aerial.nvim",
	opts = {},
	-- Optional dependencies
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	-- on_attach = function(bufnr)
	-- 	-- Jump forwards/backwards with '{' and '}'
	-- 	vim.keymap.set("n", "<c-", "<cmd>AerialPrev<CR>", { buffer = bufnr })
	-- 	vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
	-- end,
}
