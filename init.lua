local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)


vim.g.mapleader = " "       -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.maplocalleader = "\\" -- Same for `maplocalleader`

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true
vim.opt.number = true

require("lazy").setup("plugins")

vim.keymap.set('n', '<C-1>', ':NvimTreeToggle<CR>', {noremap = true})
vim.keymap.set('n', '<C-m>', vim.lsp.buf.definition, {})
vim.keymap.set('n', '<M-LeftMouse>', vim.lsp.buf.definition, {})
vim.keymap.set('n', '<C-i>', vim.lsp.buf.implementation, {})
vim.keymap.set('n', '<C-o>', vim.lsp.buf.document_symbol, {})
vim.keymap.set('n', '<C-k>', vim.lsp.buf.hover, {})

vim.o.background = "light" -- or "dark"
vim.cmd([[:hi Cursor guifg=purple guibg=purple]])
vim.cmd([[set guicursor=n-v-c:block-Cursor/lCursor]])
vim.cmd([[:hi MatchParen ctermbg=blue guibg=lightblue]])
--vim.cmd([[colorscheme gruvbox]])
