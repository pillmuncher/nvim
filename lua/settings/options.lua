-------------------------------------- Neovim Options ------------------------------------------
-- (same order as in :options, mostly)

-- 1 important
--


-- 2 moving around, searching and patterns
--
vim.opt.whichwrap:append '<>[]hl' -- list of flags specifying which commands wrap to another line
vim.opt.path:append '**'          -- Search down into subfolders.
vim.opt.cdhome = true             -- ':cd' means 'go home'.
vim.opt.ignorecase = true         -- Default to using case-insensitive searches.
vim.opt.smartcase = true          -- Use smartcase unless uppercase letters are used in the regex.


-- 3 tags
--


-- 4 displaying text
--
vim.opt.scrolloff = 1         -- Keep 1 context line above and below the cursor.
vim.opt.wrap = false          -- Don't display lines as wrapped.
vim.opt.sidescrolloff = 1     -- Only scroll sideways when one column from windo frame.
vim.opt.lazyredraw = true     -- Redraw only when we need to.
vim.opt.number = true         -- Show line numbers.
vim.opt.relativenumber = true -- Show current line as 0.
vim.opt.listchars = (         -- What to show on ':list'.
    'tab:▸ ,eol:¬,nbsp:·,trail:·,precedes:<,extends:>'
)
vim.opt.fillchars = { -- characters to use for the status line, folds and filler lines
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
vim.opt.termguicolors = true -- Enable 24-bit color suport.
vim.opt.cursorline = true    -- highlight the screen line of the cursor
vim.opt.colorcolumn = '+1'   -- Show color column.


-- 6 multiple windows
--
vim.opt.laststatus = 3      -- global statusline
vim.opt.equalalways = false -- make all windows the same size when adding/removing windows
vim.opt.splitbelow = true   -- Splits are opened below the current window.
vim.opt.splitright = true   -- Splits are opened to the right of the current window.


-- 7 multiple tab pages
--
vim.opt.showtabline = 0 -- Always show tabline, even if only one tab.


-- 8 terminal
--
vim.opt.title = true    -- Show title in console title bar.
vim.opt.titlestring = ( -- Set terminal window title.
    '%(%{hostname()}:%F%)\\ %(%M%)'
)


-- 9 using the mouse
--
vim.opt.mouse = 'ar' -- list of flags for using the mouse


-- 10 messages and info
--
vim.opt.shortmess:append 'sIa' -- list of flags to make messages shorter
vim.opt.report = 0             -- : commands always print changed line count.
vim.opt.confirm = true         -- Y-N-C prompt if closing with unsaved changes.


-- 11 selecting text
--
vim.opt.selection = 'exclusive'           -- how selecting text behaves
vim.opt.clipboard = 'unnamedplus,unnamed' -- which register yank uses


-- 12 editing text
--
vim.opt.undofile = true            -- Always keep an undo file.
vim.opt.textwidth = 80             -- Break line @ last Space before char 80.
vim.opt.formatoptions:append 'rn1' -- Set format options.
vim.opt.showmatch = true           -- Briefly jump to a paren once it's balanced.
vim.opt.matchpairs:append '<:>'    -- Use % to jump between pairs.
vim.opt.joinspaces = true          -- Use two spaces when joining lines around a '.'
vim.opt.completeopt = (            -- Autocomplete settings.
    'menuone,longest,preview'
)


-- 13 tabs and indenting
--
vim.opt.shiftwidth = 4     -- Indent four Spaces when pressing Tab in Insert Mode.
vim.opt.softtabstop = -1   -- Use shiftwidth many Spaces when pressing <Tab> or <BS>.
vim.opt.shiftround = true  -- Rounds indent to a multiple of shiftwidth.
vim.opt.expandtab = true   -- Insert Spaces instead of Tab.
vim.opt.smartindent = true -- Use smart indent if there is no indent file.


-- 14 folding
--
vim.opt.foldlevel = 99        -- Don't fold by default.
vim.opt.foldmethod = 'syntax' -- Allow folding on indents.


-- 15 diff mode
--


-- 16 mapping
--
vim.opt.timeoutlen = 400 -- time in msec for 'timeout'


-- 17 reading and writing files
--
vim.opt.fileformats = 'unix,dos,mac' -- Try recognizing dos, unix, and mac line endings.
vim.opt.backup = true                -- Always write backup file.
vim.opt.autowrite = false            -- Never write a file unless I request it.
vim.opt.autowriteall = false         -- NEVER.
vim.opt.autoread = false             -- Don't automatically re-read changed files.
vim.opt.patchmode = ''               -- Keep oldest version if a file, append .old.
vim.opt.backupdir = vim.fn.expand(   -- Always write backup file.
    '$XDG_STATE_HOME/nvim/backup//'
)


-- 18 the swap file
--
vim.opt.updatetime = 250 -- interval for writing swap file to disk, also used by gitsigns


-- 19 command line editing
--
vim.opt.wildignore = ( -- Ignore specific patterns in file completion.
    '*.o,*.obj,eggs/**,*.egg-info/**,.git,*.pyc,*.pyo,*.old'
)


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
vim.opt.virtualedit = 'block' -- Let cursor move past the last char in v mode.
vim.opt.signcolumn = 'yes'    -- When and how to draw the signcolumn.
