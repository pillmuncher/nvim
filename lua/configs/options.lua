-------------------------------------- globals -----------------------------------------
-- local config = require("core.utils").load_config()
-- vim.g.transparency = config.ui.transparency
-- vim.g.toggle_theme_icon = "   "
-- vim.g.undotree_WindowLayout = 4
-- vim.g.undotree_SetFocusWhenToggle = 1

-------------------------------------- options ------------------------------------------

-- disable some default providers
-- for _, provider in ipairs { "node", "perl", "python3", "ruby" } do
--   vim.g["loaded_" .. provider .. "_provider"] = 0
-- end

-- add binaries installed by mason.nvim to path
-- local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
-- vim.env.PATH = vim.fn.stdpath "data" .. "/mason/bin" .. (is_windows and ";" or ":") .. vim.env.PATH

-------------------------------------- autocmds ------------------------------------------
-- dont list quickfix buffers
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

-------------------------------- Highlight on yank --------------------------------------
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-------------------------------------- Neovim Options ------------------------------------------
-- (same order as in :options)


-- 1 important
--


-- 2 moving around, searching and patterns
--
vim.opt.whichwrap:append "<>[]hl"
vim.opt.path:append '**' -- Search down into subfolders.
vim.opt.cdhome = true -- ':cd' means 'go home'.
vim.opt.ignorecase = true -- Default to using case-insensitive searches.
vim.opt.smartcase = true -- Use smartcase unless uppercase letters are used in the regex.


-- 3 tags
--


-- 4 displaying text
--
vim.opt.scrolloff = 1 -- Keep 1 context line above and below the cursor.
vim.opt.wrap = false -- Don't display lines as wrapped.
vim.opt.sidescrolloff = 1 -- Only scroll sideways when one column from windo frame.
vim.opt.fillchars = { eob = " " }
vim.opt.lazyredraw = true -- Redraw only when we need to.
vim.opt.listchars = 'tab:▸ ,eol:¬,nbsp:·,trail:·,precedes:<,extends:>'  -- What to show on ':list'.
vim.opt.number = true -- Show line numbers.
vim.opt.relativenumber = true -- Show current line as 0.
-- vim.opt.numberwidth = 4


-- 5 syntax, highlighting and spelling
--
vim.opt.termguicolors = true -- Enable 24-bit color suport.
vim.opt.cursorline = true
vim.opt.colorcolumn = "+1" -- Show color column.


-- 6 multiple windows
--
vim.opt.laststatus = 3 -- global statusline
vim.opt.splitbelow = true -- Splits are opened below the current window.
vim.opt.splitright = true -- Splits are opened to the right of the current window.


-- 7 multiple tab pages
--
vim.opt.showtabline = 2 -- Always show tabline, even if only one tab.


-- 8 terminal
--
vim.opt.title = true -- Show title in console title bar.
vim.opt.titlestring = '%(%{hostname()}:%F%)\\ %(%M%)' -- Set terminal window title.


-- 9 using the mouse
--
vim.opt.mouse = "a"


-- 10 messages and info
--
vim.opt.shortmess:append "sIa"
-- vim.opt.showmode = false
-- vim.opt.ruler = true -- Show file stats.
vim.opt.report = 0 -- : commands always print changed line count.
vim.opt.confirm = true -- Y-N-C prompt if closing with unsaved changes.


-- 11 selecting text
--
vim.opt.selection = 'exclusive'
vim.opt.clipboard = 'unnamedplus,unnamed'


-- 12 editing text
--
vim.opt.undofile = true -- Always keep an undo file.
vim.opt.textwidth = 80 -- Break line @ last Space before char 80.
vim.opt.formatoptions:append 'rn1' -- Set format options.
vim.opt.completeopt = 'menuone,longest,preview' -- Autocomplete settings.
vim.opt.showmatch = true -- Briefly jump to a paren once it's balanced.
vim.opt.matchpairs:append '<:>' -- Use % to jump between pairs.
vim.opt.joinspaces = true -- Use two spaces when joining lines around a '.'


-- 13 tabs and indenting
--
vim.opt.shiftwidth = 4 -- Indent four Spaces when pressing Tab in Insert Mode.
vim.opt.softtabstop = -1 -- Use shiftwidth many Spaces when pressing <Tab> or <BS>.
vim.opt.shiftround = true -- Rounds indent to a multiple of shiftwidth.
vim.opt.expandtab = true -- Insert Spaces instead of Tab.
vim.opt.smartindent = true -- Use smart indent if there is no indent file.


-- 14 folding
--
vim.opt.foldlevel = 99 -- Don't fold by default.
vim.opt.foldmethod = 'syntax' -- Allow folding on indents.


-- 15 diff mode
--


-- 16 mapping
--
vim.opt.timeoutlen = 400


-- 17 reading and writing files
--
vim.opt.fileformats = 'unix,dos,mac' -- Try recognizing dos, unix, and mac line endings.
vim.opt.backup = true -- Always write backup file.
vim.opt.backupdir = vim.fn.expand("$XDG_STATE_HOME/nvim/backup//") -- Always write backup file.
vim.opt.autowrite = false -- Never write a file unless I request it.
vim.opt.autowriteall = false -- NEVER.
vim.opt.autoread = false -- Don't automatically re-read changed files.
vim.opt.patchmode = '' -- Keep oldest version if a file, append .old.


-- 18 the swap file
--
vim.opt.updatetime = 250 -- interval for writing swap file to disk, also used by gitsigns


-- 19 command line editing
--
vim.opt.wildignore = '*.o,*.obj,eggs/**,*.egg-info/**,.git,*.pyc,*.pyo,*.old' -- Ignore specific patterns in file completion.


-- 20 executing external commands
--
vim.opt.grepprg = 'rg --vimgrep' -- Replace the default grep program with ripgrep.


-- 21 running make and jumping to errors (quickfix)
--


-- 22 language specific
--


-- 23 multi-byte characters
--


-- 24 various
--
vim.opt.virtualedit = 'block' -- Let cursor move past the last char in <C-v> mode.
vim.opt.signcolumn = "yes"  -- When and how to draw the signcolumn.
