return {
	{
		"michaelschiff/nvim-todo",
		dir = "/home/michaelschiff/Documents/nvim-todo",
		config = function()
			-- need to requre the package for init side effects
			local todo = require("todo")
			-- todo.setup({
			-- 	repo_template = "https://github.com/Arize-ai/arize/pull",
			-- 	users = {
			-- 		"harjsing7",
			-- 		"apesternikov",
			-- 		"shiwen1209",
			-- 		"nader-azari",
			-- 		"fjcasti1",
			-- 	}
			-- })
			-- vim.keymap.set('n', 'ff', todo.toggleDescription, {})
			-- vim.keymap.set('n', 'to', todo.openPRLink, {})
		end,
	},
}
