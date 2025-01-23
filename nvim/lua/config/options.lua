-- [[ Setting options ]]
-- See `:help vim.opt`
--  For more options, you can see `:help option-list`-- Set to true if you have a Nerd Font installed and selected in the terminal

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE(jm): Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.loaded_netrw = 1       -- disable netrw
vim.g.loaded_netrwPlugin = 1 --  disable netrw


local opt = vim.opt

opt.backup = false -- creates a backup file
-- Write the buffer on various events that switch to another buffer
-- e.g. Ctrl+], Ctrl+O, :buffer, etc.
opt.autowrite = true -- Enable auto write

-- Indentation using 4 spaces
opt.shiftround = true     -- Round indent - indent to multiple of 'shiftwidth'
opt.shiftwidth = 4        -- size of an indent
-- opt.cindent = true -- enables automatic C program indenting
opt.smartindent = true    -- Insert indents automatically - universal (not only C)
opt.expandtab = true      -- insert spaces instead of tab-char
opt.tabstop = 4           -- Number of spaces tabs count for

opt.number = true         -- Print line number
opt.relativenumber = true -- Relative line numbers

-- Don't show the mode, since it's already in the status line
opt.showmode = false

-- Sync clipboard between OS and Neovim - `p` also pastes from the clipboard
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  TODO(jm): See `:help 'clipboard'`
vim.schedule(function()
  -- only set clipboard if not in ssh, to make sure the OSC 52
  -- integration works automatically. Requires Neovim >= 0.10.0
  opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
end)

-- enabled menus for ins-completion
opt.completeopt = "menu,menuone,noselect"
-- opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
opt.conceallevel = 0       -- so that `` is visible in markdown files
opt.fileencoding = "utf-8" -- the encoding written to a file
opt.confirm = true         -- Confirm to save changes before exiting modified buffer
-- opt.fillchars = {
--   foldopen = "",
--   foldclose = "",
--   fold = " ",
--   foldsep = " ",
--   diff = "╱",
--   eob = " ",
-- }
-- opt.foldlevel = 99
-- opt.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"


-- Enable break indent
opt.breakindent = true

-- Save undo history
-- undofile for each buffer - undo after closing and reopening the buffer
-- by default undofile is under `${XDG_DATA_HOME}/nvim-data/undo/`
opt.undofile = true
opt.undolevels = 1000


-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
opt.ignorecase = true
opt.smartcase = true

-- Keep signcolumn on by default
opt.signcolumn = "yes"

-- Decrease update time
opt.updatetime = 200 -- Save swap file and trigger CursorHold
-- opt.updatetime = 250

-- Decrease mapped sequence wait time
opt.timeoutlen = 300

-- Configure how new splits should be opened
opt.splitright = true -- Put new windows right of current
opt.splitbelow = true -- Put new windows below current

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
opt.inccommand = 'split'

-- Show which line your cursor is on
opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
opt.scrolloff = 10

-- Shows the effects of |:substitute|, |:smagic|, |:snomagic| and user commands with the |:command-preview| flag
opt.inccommand = "nosplit" -- preview incremental substitute
opt.jumpoptions = "view"   -- List of words that change the behavior of the |jumplist|.
opt.laststatus = 3         -- global statusline - always and ONLY the last window
opt.linebreak = true       -- Wrap lines at convenient points
opt.wrap = false           -- Disable line wrap
-- opt.mouse = "a" -- Enable mouse mode
opt.pumblend = 10          -- Popup blend (pseudo-transparency)
opt.pumheight = 10         -- Maximum number of entries in a popup (ins-completion-menu)
opt.ruler = false          -- Disable the default ruler - line and column number of the cursor position

opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }


-- Avoid all the |hit-enter| prompts caused by file messages
-- W - don't give "written" or "[w]" when writing a file *shm-W*
-- A - don't give the "ATTENTION" message when an existing *shm-A* swap file is found
-- I - don't give the intro message when starting Vim, *shm-I* see |:intro|
-- c - don't give |ins-completion-menu| messages; for *shm-c*
--     example, "-- XXX completion (YYY)", "match 1 of 2", "The only
--     match", "Pattern not found", "Back at original", etc.
-- C - don't give messages while scanning for ins-completion *shm-C* items, for instance "scanning tags"
opt.shortmess:append({ W = true, I = true, c = true, C = true })

opt.showmode = false     -- Dont show mode since we have a statusline
opt.signcolumn = "yes"   -- Always show the signcolumn, otherwise it would shift the text each time
opt.spelllang = { "en" } -- When the 'spell' option is on spellchecking will be done for these languages
opt.showtabline = 0      -- always show tabs
opt.numberwidth = 4      -- set number column width {default 4}
-- scroll behavior when opening, closing or resizing horizontal splits.
opt.splitkeep = "screen" -- Keep the text on the same screen line

-- opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]
opt.termguicolors = true           -- True color support
opt.virtualedit = "block"          -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5                -- Minimum window width

opt.smoothscroll = true

-- if vim.fn.has("nvim-0.10") == 1 then
--   opt.smoothscroll = true
--   opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
--   opt.foldmethod = "expr"
--   opt.foldtext = ""
-- else
--   opt.foldmethod = "indent"
--   opt.foldtext = "v:lua.require'lazyvim.util'.ui.foldtext()"
-- end

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
