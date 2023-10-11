-- vim: ts=4 sts=4 sw=4 et
--
-- Seriously, guys. It's not like :W or :Q are mapped to anything anyway.
vim.cmd([[cnoreabbrev Q q]])
vim.cmd([[cnoreabbrev QA qa]])
vim.cmd([[cnoreabbrev Qa qa]])
vim.cmd([[cnoreabbrev qA qa]])
vim.cmd([[cnoreabbrev W w]])
vim.cmd([[cnoreabbrev WA wa]])
vim.cmd([[cnoreabbrev Wa wa]])
vim.cmd([[cnoreabbrev wA wa]])
vim.cmd([[cnoreabbrev WQ wq]])
vim.cmd([[cnoreabbrev Wq wq]])
vim.cmd([[cnoreabbrev wQ wq]])
vim.cmd([[cnoreabbrev WQA wqa]])
vim.cmd([[cnoreabbrev WQa wqa]])
vim.cmd([[cnoreabbrev WqA wqa]])
vim.cmd([[cnoreabbrev Wqa wqa]])
vim.cmd([[cnoreabbrev wQA wqa]])
vim.cmd([[cnoreabbrev wQa wqa]])
vim.cmd([[cnoreabbrev wqA wqa]])

-- n, v, i, x, t = mode names
--
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

vim.keymap.set({ "i", "n" }, "<C-p>", "<CMD> term python <CR>",
    { desc = "New python terminal", noremap = true, silent = true, })
vim.keymap.set({ "i", "n" }, "<C-t>", "<CMD> term <CR>", { desc = "New terminal", noremap = true, silent = true })

-- Quickfix
vim.keymap.set("n", "<leader>qf", ":copen<CR>", { desc = "Open QuickFix window" })

vim.keymap.set("n", '<M-Up>', "<CMD> wincmd k<CR>:resize -2 <CR>",
    { desc = "Increase lower window size", noremap = true })
vim.keymap.set("n", "<M-Down>", "<CMD> wincmd k<CR>:resize +2 <CR>",
    { desc = "Increase upper window size", noremap = true })

vim.keymap.set("n", "<leader>db", "<CMD> bd <CR>", { desc = "Close current buffer", noremap = true, silent = true })
vim.keymap.set("n", "<leader>cb", "<CMD> enew <CR>", { desc = "New buffer", noremap = true, silent = true })

vim.keymap.set("n", "<Esc>", "<CMD> noh <CR>", { desc = "Clear highlights", noremap = true, silent = true })

vim.keymap.set("n", "<leader>n", "<CMD> set nu! <CR>", { desc = "Toggle line number", noremap = true, silent = true })
vim.keymap.set("n", "<leader>rn", "<CMD> set rnu! <CR>",
    { desc = "Toggle relative number", noremap = true, silent = true })

vim.keymap.set("n", "ya", "<CMD> %y+ <CR>", { desc = "Yank current buffer", noremap = true, silent = true })
vim.keymap.set("n", "yw", "mcviwy`c", { desc = "Yank current word", noremap = true, silent = true })
vim.keymap.set("x", "<leader>p", 'p:let @+=@0<CR>:let @"=@0<CR>',
    { desc = "Paste w/o replacing register", noremap = true, silent = true })

vim.keymap.set("n", '<C-Up>', '<C-w>k', { desc = "Change to window above", noremap = true, silent = true })
vim.keymap.set("n", '<C-Down>', '<C-w>j', { desc = "Change to window below", noremap = true, silent = true })
vim.keymap.set("n", '<C-Left>', '<C-w>h', { desc = "Change to window on the left", noremap = true, silent = true })
vim.keymap.set("n", '<C-Right>', '<C-w>l', { desc = "Change to window on the right", noremap = true, silent = true })

vim.keymap.set("n", '<leader><CR>', '<CMD> set list!<CR>', { desc = "???", noremap = true, silent = true })

vim.keymap.set("n", '<leader>wd', '<CMD> lcd %:p:h<CR>',
    { desc = "`cd` to folder of file in current buffer", noremap = true, silent = true })

vim.keymap.set({ "n", "v" }, 'W', 'gqip',
    { desc = "Wrap paragraph", noremap = true, silent = true })

vim.keymap.set("t", "<Esc>", vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true),
    { desc = "Escape terminal mode", noremap = true, silent = true })

vim.keymap.set("v", "<", "<gv", { desc = "Dedent line", noremap = true, silent = true, })
vim.keymap.set("v", ">", ">gv", { desc = "Indent line", noremap = true, silent = true, })

vim.keymap.set('n', '<m-=>', '<c-w>=',
    { desc = "Set all windows in the current tab to equal size", noremap = true, silent = true })
vim.keymap.set('i', '<m-=>', '<esc><c-w>=a',
    { desc = "Set all windows in the current tab to equal size", noremap = true, silent = true })

vim.keymap.set('n', '<m-_>', '<c-w>_',
    { desc = "Maximize height of the current window", noremap = true, silent = true })
vim.keymap.set('i', '<m-_>', '<esc><c-w>_a',
    { desc = "Maximize height of the current window", noremap = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev,
    { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next,
    { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float,
    { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>qd', vim.diagnostic.setloclist,
    { desc = 'Open diagnostics list' })


-- nnoremap <leader>ev :vsplit $MYVIMRC<cr> - Open the Neovim configuration file.
-- nnoremap <leader>sv :source $MYVIMRC<cr> - Source the Neovim configuration file.
-- nnoremap <leader>w :w<cr> - Save the current file.
-- nnoremap <leader>q :q<cr> - Quit the current window.
-- nnoremap <leader>wq :wq<cr> - Save and quit the current window.
-- nnoremap <leader>p :Files<cr> - Open the file explorer.
-- nnoremap <leader>b :Buffers<cr> - Open the buffer list.
-- nnoremap <leader>h :nohlsearch<cr> - Remove the search highlight.
-- nnoremap <leader>n :NERDTreeToggle<cr> - Toggle the NERDTree file explorer.
-- nnoremap <leader>t :FZF<cr> - Open the FZF fuzzy finder.
-- nnoremap <leader>/ :CommentToggle<cr> - Toggle comments.
-- nnoremap <leader>y :%y+<cr> - Yank the current file to the clipboard.
-- nnoremap <leader>p :%p<cr> - Paste from the clipboard to the current file.
-- nnoremap <leader>u :UndotreeToggle<cr> - Toggle the undo tree.
-- nnoremap <leader>c :ColorizerToggle<cr> - Toggle the colorizer.
-- nnoremap <leader>a :ALEFix<cr> - Fix the current file with ALE.
-- nnoremap <leader>d :ALEDetail<cr> - Show the ALE details.
-- nnoremap <leader>l :ALELint<cr> - Lint the current file with ALE.
-- nnoremap <C-p> :Ggrep<cr> - Search for a pattern in the git repo.
-- nnoremap <C-n> :Gngrep<cr> - Search for a pattern in the git repo, excluding the current file.
-- nnoremap <C-x> :Bdelete<cr> - Delete the current buffer.
-- nnoremap <C-s> :w<cr> - Save the current file.
-- nnoremap <C-z> u - Undo the last change.
-- nnoremap <C-r> <C-r> - Redo the last change.
-- nnoremap <C-a> ggVG - Select all text in the current buffer.
-- nnoremap <C-f> :ALEFix<cr> - Fix the current file with ALE.
-- nnoremap <C-g> :ALEDetail<cr> - Show the ALE details.
-- nnoremap <C-h> :ALELint<cr> - Lint the current file with ALE.
-- nnoremap <C-p> :Ggrep<cr> - Search for a pattern in the git repo.
-- nnoremap <C-n> :Gngrep<cr> - Search for a pattern in the git repo, excluding the current file.
-- nnoremap <C-x> :Bdelete<cr> - Delete the current buffer.
-- nnoremap <C-s> :w<cr> - Save the current file.
-- nnoremap <C-z> u - Undo the last change.
-- nnoremap <C-r> <C-r> - Redo t
