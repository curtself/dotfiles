vim.cmd.colorscheme("habamax")

-- Key mappings
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.wrap = false
vim.o.scrolloff = 10
vim.o.sidescrolloff = 8

-- Indentation
vim.o.tabstop = 4
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.autoindent = true

-- Search settings
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = false
vim.o.incsearch = true

-- Visual settings
vim.o.termguicolors = true
vim.o.signcolumn = "yes"
vim.o.colorcolumn = "100"
vim.o.showmatch = true
vim.o.matchtime = 2
vim.o.cmdheight = 1
vim.o.completeopt = "menuone,noinsert,noselect"
vim.o.pumheight = 10
vim.o.pumblend = 0
vim.o.winblend = 0
vim.o.conceallevel = 0
vim.o.concealcursor = ""
vim.o.lazyredraw = true
vim.o.synmaxcol = 300

-- Command shortcuts
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>rc", ":e ~/.config/nvim/init.lua<CR>", { desc = "Edit config" })
-- Remap Visual Block mode key because ctrl+v is sought-after by all
vim.keymap.set("n", "<leader>vb", "<C-v>", { noremap = true })

-- File handling
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false
vim.o.undofile = true
vim.opt.undodir = vim.fn.expand("~/.vim/undodir")
vim.o.updatetime = 300
vim.o.timeoutlen = 500
vim.o.ttimeoutlen = 0
--vim.o.autoread = true
vim.o.autowrite = false

-- Clear search highlight
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>")
-- Center screen when jumping
vim.keymap.set("n", "n", "nzzzv" )
vim.keymap.set("n", "N", "Nzzzv" )
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- paste over text but do not replace copy buffer
vim.keymap.set("x", "<leader>p", "\"_dP")
-- <leader>y allows yank to go to the system clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")
-- these let you delete to void (keep copy buffer as is)
vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")
-- allows jj to exit edit/insert mode
vim.keymap.set("i", "jj", "<Esc>")
-- apparently Q is normally a very bad key to hit
vim.keymap.set("n", "Q", "<nop>")
-- Buffer navigation
vim.keymap.set("n", "<leader>bn", ":bnext<CR>")
vim.keymap.set("n", "<leader>bp", ":bprev<CR>")

-- Better window navigation (control+Vim motions to jump panes/windows)
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })


-- Splitting and resizing
vim.o.splitright = true
vim.o.splitbelow = true
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>")
vim.keymap.set("n", "<leader>sh", ":split<CR>")
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>")
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>")
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>")
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>")

-- Move selected lines up/down
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==")
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==")
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")
-- move selected lines up or down

-- Better indenting in visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Return to last edit position when opening files
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  callback = function()
      local mark = vim.api.nvim_buf_get_mark(0, '"')
      local lcount = vim.api.nvim_buf_line_count(0)
      if mark[1] > 0 and mark[1] <= lcount then
          pcall(vim.api.nvim_win_set_cursor, 0, mark)
      end
  end
})

-- Create undo directory if it does not exist
local undodir = vim.fn.expand("~/.vim.undodir")
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
end

-- Other includes here (like plugins or more complex stuff
-- require("curt.terminal") -- need to copy this from WSL

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require("config.plugins")

vim.keymap.set("n", "<leader>f", function()
  vim.lsp.buf.format()
end)
