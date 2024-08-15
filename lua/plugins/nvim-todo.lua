return {
	{
		"michaelschiff/nvim-todo",
		dir = "/Users/michaelschiff/Documents/nvim-todo",
		config = function()
			-- need to requre the package for init side effects
			local todo = require("todo")
			vim.keymap.set('n', 'ff', todo.toggleDescription, {})
			vim.keymap.set('n', 'to', todo.openPRLink, {})
		end,
	},
}
