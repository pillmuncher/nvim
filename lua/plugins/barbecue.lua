local function split(input, delimiter)
	local arr = {}
	local _ = string.gsub(input, "[^" .. delimiter .. "]+", function(w)
		table.insert(arr, w)
	end)
	return arr
end

-- local function get_venv()
--     local venv = vim.env.VIRTUAL_ENV
--     if venv then
--         local params = split(venv, '-')
--         return params[#params] .. ' '
--     else
--         return ''
--     end
-- end

local function get_project_name()
	-- Find project.clj
	local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null || pwd")
	if not handle then
		return ""
	end
	local root = handle:read("*l")
	handle:close()

	local f = io.open(root .. "/project.clj", "r")
	if not f then
		return ""
	end

	local content = f:read("*a")
	f:close()

	-- Extract first defproject name (symbol or string)
	local name = content:match("%(defproject%s+([%w%-%._/]+)") or ""
	if name ~= "" then
		return name .. " "
	end
	return ""
end

local function get_venv_or_project()
	if vim.fn.filereadable("project.clj") == 1 then
		return get_project_name()
	end
	local venv = vim.env.VIRTUAL_ENV
	if venv then
		local params = vim.split(venv, "-", { plain = true })
		return params[#params] .. " "
	end
	return ""
end

return {
	"utilyre/barbecue.nvim",
	lazy = false,
	priority = 100000,
	name = "barbecue",
	dependencies = {
		{ "ramojus/mellifluous.nvim" },
		{ "SmiteshP/nvim-navic" },
		{ "nvim-tree/nvim-web-devicons" },
	},
	opts = {
		create_autocmd = true,
		show_dirname = false,
		show_basename = false,
		custom_section = get_venv_or_project,
	},
}
-- return {
--     'utilyre/barbecue.nvim',
--     lazy         = false,
--     priority     = 100000,
--     name         = 'barbecue',
--     dependencies = {
--         { 'ramojus/mellifluous.nvim' },
--         { 'SmiteshP/nvim-navic' },
--         { 'nvim-tree/nvim-web-devicons' },
--     },
--     opts         = {
--         create_autocmd = true,
--         show_dirname = false,
--         show_basename = false,
--         custom_section = get_venv,
--     },
-- }
