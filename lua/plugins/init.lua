return {
	{ 'f-person/git-blame.nvim' },
	{ 'nvim-tree/nvim-web-devicons', config = function() require('nvim-web-devicons').setup({}) end },
    
    -- comment/uncomment the current line or selected visual block
	{ "numToStr/Comment.nvim", opts = {}, config = function () require("Comment").setup() end},

    -- Color theming plugin
    { "rebelot/kanagawa.nvim" },
}
