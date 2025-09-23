local M = {}

function M.setup(client, bufnr)
	local bufopts = { noremap = true, silent = true, buffer = bufnr }

	-- Navigation
	vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", bufopts)
	vim.keymap.set("n", "gh", "<cmd>lua vim.lsp.buf.hover()<CR>", bufopts)
	vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", bufopts)
	vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", bufopts)

	-- Diagnostics
	vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", bufopts)
	vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", bufopts)

	-- Pyright-specific commands
	if client.name == "pyright" then
		vim.api.nvim_buf_create_user_command(bufnr, "LspPyrightOrganizeImports", function()
			client:exec_cmd({
				command = "pyright.organizeimports",
				arguments = { vim.uri_from_bufnr(bufnr) },
			})
		end, { desc = "Organize Imports" })
	end
end

return M
