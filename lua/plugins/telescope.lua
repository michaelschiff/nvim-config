return {
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.6',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			local builtin = require('telescope.builtin')
			vim.keymap.set('n', '<C-f><C-f>', builtin.find_files, {})
			vim.keymap.set('n', '<C-n>', builtin.lsp_references, {})
			vim.keymap.set('n', '<C-j>', builtin.lsp_incoming_calls, {})
			--TODO(michaelschiff): the binding below have nothing to do with telescope and should
			-- probably live somewhere else.  What is the right way to manage keymappings
			vim.keymap.set('n', '<C-m>', vim.lsp.buf.definition, {})
			vim.keymap.set('n', '<M-LeftMouse>', vim.lsp.buf.definition, {})
			vim.keymap.set('n', '<C-i>', vim.lsp.buf.implementation, {})
			vim.keymap.set('n', '<C-o>', vim.lsp.buf.document_symbol, {})
		end,
	},
}
