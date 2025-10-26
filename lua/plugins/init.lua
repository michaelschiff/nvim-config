return {
	{ 'f-person/git-blame.nvim' },
	{ 'nvim-tree/nvim-web-devicons', config = function() require('nvim-web-devicons').setup({}) end },
	-- nvim-jdtls configuration is in ftplugin directory
	--{ "mfussenegger/nvim-jdtls" },
	-- { "windwp/nvim-autopairs",  config = function() require("nvim-autopairs").setup({}) end },
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	{ "williamboman/mason.nvim", config = function () require("mason").setup() end },

        -- comment/uncomment the current line or selected visual block
	{ "numToStr/Comment.nvim", opts = {}, config = function () require("Comment").setup() end},

        -- Color theming plugin
        { "rebelot/kanagawa.nvim" },
}
