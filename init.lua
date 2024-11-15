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
vim.keymap.set('n', '<C-1>', ':NvimTreeToggle<CR>', {noremap = true})
--vim.keymap.set('n', '<C-[>', ':bp<CR>', {noremap = true})
--vim.keymap.set('n', '<C-]>', ':bn<CR>', {noremap = true})

-- LSP and programming keymaps
vim.keymap.set('n', '<C-m>', vim.lsp.buf.definition, {})
vim.keymap.set('n', '<C-i>', vim.lsp.buf.implementation, {})
vim.keymap.set('n', '<C-o>', vim.lsp.buf.document_symbol, {})
vim.keymap.set('n', '<C-k>', vim.lsp.buf.hover, {})
vim.keymap.set('n', '<C-l>', vim.lsp.buf.code_action, {})
vim.keymap.set('n', '<C-c>', vim.lsp.buf.completion, {})
vim.keymap.set('n', '<C-e>', vim.diagnostic.open_float, {})

-- code folding
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = "v:lua.vim.treesitter.foldtext()"


-- appearance and vim commands
vim.o.background = "light" -- or "dark"
vim.cmd([[:hi Cursor guifg=purple guibg=purple]])
vim.cmd([[set guicursor=n-v-c:block-Cursor/lCursor]])
vim.cmd([[:hi MatchParen ctermbg=blue guibg=lightblue]])
vim.cmd([[colorscheme gruvbox]])

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

