return {
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.6',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			local builtin = require('telescope.builtin')
			vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
			vim.keymap.set('n', '<leader>n', builtin.lsp_references, {})
			vim.keymap.set('n', '<leader>j', builtin.lsp_incoming_calls, {})
		end,
	},
}
