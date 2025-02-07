-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- source keybinds
-- vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>")
-- vim.keymap.set("n", "<leader>x", "<cmd>.lua<CR>")
-- vim.keymap.set("v", "<leader>x", "<cmd>lua<CR>")

-- [[ Line navigation  ]]
-- NOTE(jm): In insert mode
--    - <C-W> deletes a WORD to the left
--    - <C-h> deletes a character to the left
vim.keymap.set("i", "<A-j>", "<Down>", { desc = "Cursor Down" })
vim.keymap.set("i", "<A-k>", "<Up>", { desc = "Cursor Up" })
vim.keymap.set("i", "<A-l>", "<Right>", { desc = "Cursor Right" })
vim.keymap.set("i", "<A-h>", "<Left>", { desc = "Cursor Left" })
-- Move Lines
-- vim.keymap.set("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<CR>==", { desc = "Move Down" })
-- vim.keymap.set("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<CR>==", { desc = "Move Up" })
-- vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<CR>==gi", { desc = "Move Down" })
-- vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<CR>==gi", { desc = "Move Up" })
vim.keymap.set("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
vim.keymap.set("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })
-- Move to start/end of line
vim.keymap.set({ "n", "x", "o", "v" }, "<S-h>", "^", { desc = "Start of Line" })
vim.keymap.set({ "n", "x", "o", "v" }, "<S-l>", "g_", { desc = "End of Line" })
-- Move to matching brackets
vim.keymap.set({ "n", "v", "x", "o" }, "<S-j>", "%", { desc = "Matching Brackets" })

-- paste over currently selected text without yanking it
-- vim.keymap.set("v", "p", '"0p')
-- vim.keymap.set("v", "P", '"0P')


-- [[ Buffers ]]
vim.keymap.set("n", "[b", "<cmd>bprevious<CR>", { desc = "Prev Buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>bb", "<cmd>e #<CR>", { desc = "Switch to Other Buffer" })
vim.keymap.set("n", "<leader>`", "<cmd>e #<CR>", { desc = "Switch to Other Buffer" })
-- vim.keymap.set("n", "<leader>bd", function()
--   Snacks.bufdelete()
-- end, { desc = "Delete Buffer" })
-- vim.keymap.set("n", "<leader>bo", function()
--   Snacks.bufdelete.other()
-- end, { desc = "Delete Other Buffers" })
vim.keymap.set("n", "<leader>bd", "<cmd>bd<CR>", { desc = "Delete Buffer and Window" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Add undo break-points
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", ";", ";<c-g>u")

-- save file
-- vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<CR><esc>", { desc = "Save File" })

-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- commenting
vim.keymap.set("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<CR>fxa<bs>", { desc = "Add Comment Below" })
vim.keymap.set("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<CR>fxa<bs>", { desc = "Add Comment Above" })

-- location list
vim.keymap.set("n", "<leader>xl", "<cmd>lopen<CR>", { desc = "Location List" })

-- quickfix list
vim.keymap.set("n", "<leader>xq", "<cmd>copen<CR>", { desc = "Quickfix List" })
vim.keymap.set("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
vim.keymap.set("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })
-- vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>")
-- vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>")

-- formatting
-- vim.keymap.set({ "n", "v" }, "<leader>cf", function()
--   JVim.format({ force = true })
-- end, { desc = "Format" })


-- Clangd commands keymaps
-- TODO(jm): This should be moved to clangd-on-load function. Otherwise this keymap does not make any sense.
vim.keymap.set("n", "<M-o>", "<cmd>ClangdSwitchSourceHeader<CR>")


-- quit
vim.keymap.set("n", "<leader>qq", "<cmd>qa<CR>", { desc = "Quit All" })

-- highlights under cursor
vim.keymap.set("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
vim.keymap.set("n", "<leader>uI", "<cmd>InspectTree<CR>", { desc = "Inspect Tree" })

-- Toggle options
vim.keymap.set("n", "<leader>0",
  function() JVim.toggle_option("relativenumber", "Relative Line Numbers") end,
  { desc = "Toggle Relative Line Numbers" }
)
-- vim.keymap.set("n", "<leader>c-f",
--   function() JVim.toggle_global("autoformat", "Autoformat on Save") end,
--   { desc = "Toggle Autoformat on Save" })
