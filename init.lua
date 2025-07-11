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
vim.o.background = "dark"

vim.cmd([[set expandtab]])

-- "global" window options
vim.api.nvim_create_autocmd({'BufRead'}, {pattern = "*", callback = function ()
	vim.wo.colorcolumn = "95"
end})

-- goimports and gofmt on save
vim.api.nvim_create_autocmd({"BufWritePre"}, {
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    -- buf_request_sync defaults to a 1000ms timeout. Depending on your
    -- machine and codebase, you may want longer. Add an additional
    -- argument after params if you find that you have to write the file
    -- twice for changes to be saved.
    -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({async = false})
  end
})
