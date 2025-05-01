return {
	"lewis6991/gitsigns.nvim",
	-- lazy = false,
	config = function()
		require("gitsigns").setup({
			-- See `:help gitsigns.txt`
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		})
	end,
	event = { "BufReadPre", "BufNewFile" },
}
