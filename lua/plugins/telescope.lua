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
		end,
	},
}
