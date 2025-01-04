return {
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("nvim-tree").setup({
				view = { adaptive_size = true },
                                filters = {
                                        custom = {'bazel-arize', 'bazel-bin', 'bazel-out', 'bazel-testlogs'}
                                }
			})
			-- uncomment the following line to open the tree view on startup
			--require("nvim-tree.api").tree.open()
		end,
	},
}
