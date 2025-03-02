-- be more concise:
local opt = vim.opt

-- same order as in :options, mostly

-- 1 important
--


-- 2 moving around, searching and patterns
--
opt.whichwrap:append '<>[]hl' -- list of flags specifying which commands wrap to another line
opt.path:append '**'          -- Search down into subfolders.
opt.cdhome = true             -- ':cd' means 'go home'.
opt.ignorecase = true         -- Default to using case-insensitive searches.
opt.smartcase = true          -- Use smartcase unless uppercase letters are used in the regex.


-- 3 tags
--


-- 4 displaying text
--
opt.scrolloff = 1         -- Keep 1 context line above and below the cursor.
opt.wrap = false          -- Don't display lines as wrapped.
opt.sidescrolloff = 1     -- Only scroll sideways when one column from window frame.
opt.lazyredraw = true     -- Redraw only when we need to.
opt.number = true         -- Show line numbers.
opt.relativenumber = true -- Show current line as 0.
opt.listchars = {         -- What to show on ':list'.
    tab = '▸ ',
    eol = '¬',
    nbsp = '·',
    trail = '·',
    precedes = '<',
    extends = '>',
}
opt.fillchars = { -- status line, folds and filler line characters:
    vert = '|', -- vertical split separators
    fold = ' ', -- folded lines
    eob = ' ', -- End Of Buffer area
    diff = '-', -- diff changes
    msgsep = '=', -- message separators
    foldopen = '▾', -- open folds
    foldsep = '|', -- fold separators
    foldclose = '▸', -- closed folds
}


-- 5 syntax, highlighting and spelling
--
opt.termguicolors = true -- Enable 24-bit color suport.
opt.cursorline = true    -- highlight the screen line of the cursor
opt.colorcolumn = '+1'   -- Show color column.


-- 6 multiple windows
--
opt.laststatus = 3      -- global statusline
opt.equalalways = false -- make all windows the same size when adding/removing windows
opt.splitbelow = true   -- Splits are opened below the current window.
opt.splitright = true   -- Splits are opened to the right of the current window.


-- 7 multiple tab pages
--
opt.showtabline = 0 -- Always show tabline, even if only one tab.


-- 8 terminal
--
opt.title = true    -- Show title in console title bar.
opt.titlestring = ( -- Set terminal window title.
    '%(%{hostname()}:%F%)\\ %(%M%)'
)


-- 9 using the mouse
--
opt.mouse = 'ar' -- list of flags for using the mouse


-- 10 messages and info
--
opt.shortmess:append 'sIa' -- list of flags to make messages shorter
opt.report = 0             -- : commands always print changed line count.
opt.confirm = true         -- Y-N-C prompt if closing with unsaved changes.


-- 11 selecting text
--
opt.selection = 'exclusive'           -- how selecting text behaves
opt.clipboard = 'unnamedplus,unnamed' -- which register yank uses


-- 12 editing text
--
opt.undofile = true            -- Always keep an undo file.
opt.textwidth = 80             -- Break line @ last Space before char 80.
opt.formatoptions:append 'rn1' -- Set format options.
opt.showmatch = true           -- Briefly jump to a paren once it's balanced.
opt.matchpairs:append '<:>'    -- Use % to jump between pairs.
opt.joinspaces = true          -- Use two spaces when joining lines around a '.'
opt.completeopt = (            -- Autocomplete settings.
    'menuone,longest,preview'
)


-- 13 tabs and indenting
--
opt.shiftwidth = 4     -- Indent four Spaces when pressing Tab in Insert Mode.
opt.softtabstop = -1   -- Use shiftwidth many Spaces when pressing <Tab> or <BS>.
opt.tabstop = 4        --
opt.shiftround = true  -- Rounds indent to a multiple of shiftwidth.
opt.expandtab = true   -- Insert Spaces instead of Tab.
opt.smartindent = true -- Use smart indent if there is no indent file.


-- 14 folding
--
opt.foldlevel = 99        -- Don't fold by default.
opt.foldmethod = 'syntax' -- Allow folding on indents.


-- 15 diff mode
--


-- 16 mapping
--
opt.timeoutlen = 400 -- time in msec for 'timeout'


-- 17 reading and writing files
--
opt.fileformats = 'unix,dos,mac' -- Try recognizing dos, unix, and mac line endings.
opt.backup = true                -- Always write backup file.
opt.autowrite = false            -- Never write a file unless I request it.
opt.autowriteall = false         -- NEVER.
opt.autoread = false             -- Don't automatically re-read changed files.
opt.patchmode = ''               -- Keep oldest version if a file, append .old.
opt.backupdir = vim.fn.expand(   -- Always write backup file.
    '$XDG_STATE_HOME/nvim/backup//'
)


-- 18 the swap file
--
opt.updatetime = 200 -- interval for writing swap file to disk, also used by gitsigns


-- 19 command line editing
--
opt.wildignore = ( -- Ignore specific patterns in file completion.
    '*.o,*.obj,eggs/**,*.egg-info/**,.git,*.pyc,*.pyo,*.old'
)


-- 20 executing external commands
--
opt.grepprg = 'rg --vimgrep' -- Replace the default grep program with ripgrep.


-- 21 running make and jumping to errors (quickfix)
--


-- 22 language specific
--


-- 23 multi-byte characters
--


-- 24 various
--
opt.virtualedit = 'block' -- Let cursor move past the last char in v mode.
opt.signcolumn = 'yes'    -- When and how to draw the signcolumn.


-- disable luarocks:
-- opt.rocks.enabled = false


-- GUI options:

opt.guifont = "Liga Hasklug Nerd Font:Light:14"
vim.g.neovide_transparency = 0.707
