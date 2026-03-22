-- be more concise:
local map = vim.keymap.set
local cmd = vim.cmd

-- ============================================================================
-- Command Abbreviations (fix common typos)
-- ============================================================================
local abbrevs = {
	q = { "Q" },
	qa = { "QA", "Qa", "qA" },
	w = { "W" },
	wa = { "WA", "Wa", "wA" },
	wq = { "WQ", "Wq", "wQ" },
	wqa = { "WQA", "WQa", "WqA", "Wqa", "wQA", "wQa", "wqA" },
}

for correct, typos in pairs(abbrevs) do
	for _, typo in ipairs(typos) do
		cmd.cnoreabbrev(typo, correct)
	end
end

-- ============================================================================
-- Basic Mappings
-- ============================================================================

-- Leader is space, set to Nop to prevent conflicts
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Unmap 'gc' to remove checkhealth warning (Comment.nvim handles this)
map("n", "gc", "")

-- ============================================================================
-- Load Plugin APIs
-- ============================================================================
local commentapi = require("Comment.api")
local gitsigns = require("gitsigns")
local telescope = require("telescope")
local whichkey = require("which-key")

-- ============================================================================
-- Which-Key Configuration
-- Global mappings only - LSP buffer-local mappings are in M.setup_lsp()
-- ============================================================================
whichkey.add({

	-- ========================================================================
	-- Group Labels
	-- ========================================================================
	{ "<leader>c", group = "Close" },
	{ "<leader>d", group = "Delete/Workspace" },
	{ "<leader>f", group = "Find" },
	{ "<leader>g", group = "GoTo" },
	{ "<leader>n", group = "New" },
	{ "<leader>o", group = "Open" },
	{ "<leader>r", group = "Refactor/Format" },
	{ "<leader>s", group = "Show" },
	{ "<leader>t", group = "Toggle" },
	{ "<leader>u", group = "Undo" },

	-- ========================================================================
	-- Visual Mode Enhancements
	-- ========================================================================

	-- Keep selection after indenting
	{ ">", ">gv", desc = "Indent and keep selection", mode = "v" },
	{ "<", "<gv", desc = "Dedent and keep selection", mode = "v" },

	-- Fix Shift+Arrow behavior in visual mode
	{ "<S-Down>", "<Down>", desc = "", mode = { "n", "v" }, silent = true },
	{ "<S-Up>", "<Up>", desc = "", mode = { "n", "v" }, silent = true },

	-- ========================================================================
	-- Basic Operations
	-- ========================================================================

	{ "<Esc>", "<CMD>noh<CR>", desc = "Clear search highlights", mode = "n" },
	{ "y.", "<CMD>%y+<CR>", desc = "Yank entire buffer to clipboard", mode = "n" },
	{ "<leader>p", 'p:let @+=@0<CR>:let @"=@0<CR>', desc = "Paste without replacing register", mode = "v" },

	-- ========================================================================
	-- Text Formatting
	-- ========================================================================

	{ "<leader>W", "gwip", desc = "Wrap paragraph", mode = "n" },
	{ "<leader>W", "gw", desc = "Wrap selection", mode = "v" },

	-- ========================================================================
	-- Commenting (Ctrl+#)
	-- ========================================================================

	{
		"<C-#>",
		'<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>',
		desc = "Toggle comment",
		mode = "v",
	},
	{
		"<C-#>",
		function()
			commentapi.toggle.linewise.current()
		end,
		desc = "Toggle comment",
		mode = { "i", "n" },
	},

	-- ========================================================================
	-- Window Management
	-- ========================================================================

	-- Window navigation (Ctrl + Arrow keys)
	{ "<C-Left>", "<C-W>h", desc = "Move to left window", mode = "n" },
	{ "<C-Down>", "<C-W>j", desc = "Move to window below", mode = "n" },
	{ "<C-Up>", "<C-W>k", desc = "Move to window above", mode = "n" },
	{ "<C-Right>", "<C-W>l", desc = "Move to right window", mode = "n" },

	-- Window resizing (Alt + Arrow keys) - moves divider without changing focus
	{
		"<M-Down>",
		function()
			local winnr = vim.fn.winnr()
			vim.cmd("wincmd k")
			vim.cmd("resize +2")
			vim.cmd(winnr .. "wincmd w")
		end,
		desc = "Move horizontal divider down",
		mode = "n",
	},
	{
		"<M-Up>",
		function()
			local winnr = vim.fn.winnr()
			vim.cmd("wincmd k")
			vim.cmd("resize -2")
			vim.cmd(winnr .. "wincmd w")
		end,
		desc = "Move horizontal divider up",
		mode = "n",
	},

	-- Close window/buffer intelligently
	{
		"<C-D>",
		function()
			if #vim.api.nvim_list_wins() > 1 then
				vim.api.nvim_win_close(0, true)
			else
				vim.cmd("bd")
			end
		end,
		desc = "Close window or buffer",
		mode = { "i", "n", "v", "t" },
	},

	-- ========================================================================
	-- Buffer Navigation
	-- ========================================================================

	{ "<C-PageDown>", "<CMD>bnext!<CR>", desc = "Next buffer", mode = "n" },
	{ "<C-PageUp>", "<CMD>bprev!<CR>", desc = "Previous buffer", mode = "n" },

	-- ========================================================================
	-- Terminal
	-- ========================================================================

	{
		"<C-t>",
		function()
			cmd.split()
			cmd.startinsert()
			cmd.terminal()
		end,
		desc = "New terminal (shell)",
		mode = { "n", "v" },
	},
	{
		"<C-p>",
		function()
			cmd.split()
			cmd.startinsert()
			cmd.terminal("python3")
		end,
		desc = "New terminal (Python REPL)",
		mode = { "n", "v" },
	},
	{
		"<Esc>",
		vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true),
		desc = "Exit terminal mode",
		mode = "t",
	},

	-- ========================================================================
	-- TUI Applications
	-- ========================================================================

	{ "<C-n>", "<CMD>NvimTreeToggle<CR>", desc = "Toggle file explorer", mode = { "i", "n" } },
	{ "<C-u>", "<CMD>UndotreeToggle<CR>", desc = "Toggle undo tree", mode = { "i", "n" } },
	{ "<C-g>", "<CMD>LazyGit<CR>", desc = "Open LazyGit", mode = "n" },
	{ "<C-l>", "<CMD>AerialToggle!<CR>", desc = "Toggle code outline", mode = "n" },

	-- ========================================================================
	-- WhichKey
	-- ========================================================================

	{
		"<leader><leader>",
		function()
			cmd("WhichKey " .. vim.fn.input("WhichKey: "))
		end,
		desc = "Search WhichKey",
		mode = "n",
	},

	-- ========================================================================
	-- Close/Buffer Operations
	-- ========================================================================

	{ "<leader>cb", "<CMD>bd<CR>", desc = "Close current buffer", mode = "n" },

	-- ========================================================================
	-- Find (Telescope)
	-- ========================================================================

	{ "<leader>f?", "<CMD>Telescope help_tags<CR>", desc = "Find help" },
	{
		"<leader>fa",
		"<CMD>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
		desc = "Find any file (including hidden)",
	},
	{ "<leader>fb", "<CMD>Telescope buffers<CR>", desc = "Find buffer" },
	{ "<leader>fc", "<CMD>Telescope git_commits<CR>", desc = "Find git commit" },
	{
		"<leader>fd",
		function()
			require("telescope.builtin").lsp_document_symbols({ show_line = true })
		end,
		desc = "Find document symbols",
	},
	{ "<leader>ff", "<CMD>Telescope find_files<CR>", desc = "Find file" },
	{ "<leader>fg", "<CMD>Telescope git_files<CR>", desc = "Find git-tracked file" },
	{ "<leader>fm", "<CMD>Telescope marks<CR>", desc = "Find marks" },
	{ "<leader>fr", "<CMD>Telescope oldfiles<CR>", desc = "Find recent files" },
	{ "<leader>fs", "<CMD>Telescope git_status<CR>", desc = "Find files in git status" },
	{
		"<leader>ft",
		function()
			telescope.extensions.git_worktree.git_worktrees()
		end,
		desc = "Find git worktree",
	},
	{
		"<leader>fw",
		function()
			require("telescope.builtin").lsp_dynamic_workspace_symbols()
		end,
		desc = "Find workspace symbols",
	},
	{ "<leader>fx", "<CMD>Telescope live_grep<CR>", desc = "Find text (live grep)" },

	-- ========================================================================
	-- GoTo Navigation
	-- ========================================================================

	{ "<leader>g.", "<CMD>lcd %:p:h<CR>", desc = "CD to current file's directory" },

	-- Git hunks
	{
		"<leader>gn",
		function()
			if not vim.wo.diff then
				vim.schedule(function()
					gitsigns.nav_hunk("next")
				end)
			end
		end,
		desc = "GoTo next git hunk",
	},
	{
		"<leader>gN",
		function()
			if not vim.wo.diff then
				vim.schedule(function()
					gitsigns.nav_hunk("prev")
				end)
			end
		end,
		desc = "GoTo previous git hunk",
	},

	-- Diagnostics
	{
		"[d",
		function()
			vim.diagnostic.jump({ count = -1, float = true })
		end,
		desc = "Previous diagnostic",
	},
	{
		"]d",
		function()
			vim.diagnostic.jump({ count = 1, float = true })
		end,
		desc = "Next diagnostic",
	},

	-- ========================================================================
	-- New (Create)
	-- ========================================================================

	{ "<leader>nb", "<CMD>enew<CR>", desc = "New buffer" },

	-- ========================================================================
	-- Open (Diagnostics, QuickFix, etc.)
	-- ========================================================================

	{ "<leader>od", vim.diagnostic.setloclist, desc = "Open diagnostics (loclist)" },
	{ "<leader>of", vim.diagnostic.open_float, desc = "Open diagnostic float" },
	{ "<leader>oq", "<CMD>copen<CR>", desc = "Open quickfix list", mode = { "n", "v" } },
	{
		"<C-o>",
		function()
			vim.diagnostic.setloclist({ open = true })
			cmd("lopen")
		end,
		desc = "Open diagnostics in loclist",
	},

	-- ========================================================================
	-- Show (Documentation, Blame, etc.)
	-- ========================================================================

	{ "<leader>sb", gitsigns.blame_line, desc = "Show git blame" },
	{ "<leader>sh", gitsigns.preview_hunk, desc = "Show git hunk diff" },

	-- ========================================================================
	-- Toggle
	-- ========================================================================

	{ "<leader>tc", "<CMD>set list!<CR>", desc = "Toggle listchars" },
	{ "<leader>td", gitsigns.preview_hunk_inline, desc = "Toggle deleted lines (git)" },
	{ "<leader>tn", "<CMD>set nu!<CR>", desc = "Toggle line numbers" },
	{ "<leader>tr", "<CMD>set rnu!<CR>", desc = "Toggle relative numbers" },
	{ "<leader>ti", "<CMD>IBLToggle<CR>", desc = "Toggle indent lines" },
	{ "<leader>ts", "<CMD>IBLToggleScope<CR>", desc = "Toggle scope lines" },

	-- ========================================================================
	-- IncRename
	-- ========================================================================
	{
		"<leader>rn",
		function()
			return ":IncRename " .. vim.fn.expand("<cword>")
		end,
		desc = "Rename symbol",
		mode = "n",
		expr = true,
	},
	-- ========================================================================
	-- Undo
	-- ========================================================================

	{ "<leader>uh", gitsigns.reset_hunk, desc = "Undo (reset) git hunk" },
})

-- ============================================================================
-- LSP Buffer-Local Mappings (called when LSP attaches to a buffer)
-- ============================================================================
-- These mappings only work in buffers with an attached LSP server.
-- They are buffer-local to prevent errors when calling LSP functions
-- in non-LSP buffers.
--
-- These will automatically appear in which-key menus because of the desc field!
-- ============================================================================

local M = {}

function M.setup_lsp(bufnr)
	local map_lsp = function(keys, func, desc)
		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc, noremap = true, silent = true })
	end

	-- Navigation
	map_lsp("gd", vim.lsp.buf.definition, "definition")
	map_lsp("gD", vim.lsp.buf.declaration, "declaration")
	map_lsp("gi", vim.lsp.buf.implementation, "implementation")
	map_lsp("gr", vim.lsp.buf.references, "references")
	map_lsp("<leader>gt", vim.lsp.buf.type_definition, "type definition")
	map_lsp("<leader>gi", vim.lsp.buf.implementation, "implementation")

	-- Documentation
	map_lsp("K", vim.lsp.buf.hover, "Hover documentation")
	map_lsp("<C-k>", vim.lsp.buf.signature_help, "Signature help")
	map_lsp("<leader>sd", vim.lsp.buf.hover, "documentation (hover)")
	map_lsp("<leader>ss", vim.lsp.buf.signature_help, "signature help")

	-- Code actions and refactoring
	map_lsp("<leader>ca", vim.lsp.buf.code_action, "Code actions")
	map_lsp("<leader>xa", vim.lsp.buf.code_action, "Code actions (alt)")
	-- map_lsp("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
	-- vim.keymap.set("n", "<leader>rn", function()
	-- 	return ":IncRename " .. vim.fn.expand("<cword>")
	-- end, { buffer = bufnr, desc = "Rename symbol", noremap = true, silent = true, expr = true })
	map_lsp("<leader>rf", function()
		vim.lsp.buf.format({ async = true })
	end, "Format buffer")

	-- References
	map_lsp("<leader>or", vim.lsp.buf.references, "references")

	-- Workspace folders
	map_lsp("<leader>nw", vim.lsp.buf.add_workspace_folder, "workspace folder")
	map_lsp("<leader>dw", vim.lsp.buf.remove_workspace_folder, "workspace folder")
	map_lsp("<leader>sw", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "workspace folders")
end

return M
