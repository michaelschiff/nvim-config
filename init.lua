vim.opt.runtimepath:remove('/usr/share/nvim/runtime/lua/vim/treesitter/')
vim.opt.runtimepath:remove('/usr/share/nvim/runtime/lua/vim/treesitter.lua')

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

-- disable netrw at the very start of your init.lua (for nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true
vim.opt.number = true

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.softtabstop = 4

vim.lsp.enable({'gopls', 'luals', 'bash-language-server', 'starpls', 'jls', 'superhtml', 'ts_ls', 'marksman'})

require("lazy").setup("plugins")

-- Navigation key maps
vim.keymap.set('n', '<leader>1', ':NvimTreeToggle<CR>', {noremap = true})

-- LSP and programming keymaps
vim.keymap.set('n', '<leader>m', vim.lsp.buf.definition, {})
vim.keymap.set('n', '<leader>i', vim.lsp.buf.implementation, {})
vim.keymap.set('n', '<leader>o', vim.lsp.buf.document_symbol, {})
vim.keymap.set('n', '<leader>k', vim.lsp.buf.hover, {})
vim.keymap.set('n', '<leader>af', vim.lsp.buf.format, {})
vim.keymap.set('n', '<leader><CR>', vim.lsp.buf.code_action, {})
vim.keymap.set('n', '<leader>ll', vim.diagnostic.setloclist, {})
vim.keymap.set('n', '<leader>u', vim.lsp.buf.incoming_calls, {})
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, {})

-- Telescope search 
local telescope = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', telescope.find_files, {})
vim.keymap.set('n', '<leader>fr', telescope.lsp_references, {})

-- DAP debugging
local dap = require('dap')
dap.adapters.delve = {
	type = "server",
	host = "127.0.0.1",
	port = 38697,
}
dap.configurations.go = {
  {
    type = "delve",
    name = "Debug",
    request = "launch",
    program = "${file}"
  },
  {
    type = "delve",
    name = "Debug test", -- configuration for debugging test files
    request = "launch",
    mode = "test",
    program = "${file}"
  },
  -- works with go.mod packages and sub packages 
  {
    type = "delve",
    name = "Debug test (go.mod)",
    request = "launch",
    mode = "test",
    program = "./${relativeFileDirname}"
  }
}


-- appearance and vim commands
-- vim.o.background = "light"
-- vim.o.background = "dark"
vim.cmd("colorscheme kanagawa-lotus")

vim.cmd([[set expandtab]])

-- "global" window options
vim.api.nvim_create_autocmd({'BufRead'}, {pattern = "*", callback = function ()
	vim.wo.colorcolumn = "95"
end})

