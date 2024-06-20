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


vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.maplocalleader = "\\" -- Same for `maplocalleader`

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true


require("lazy").setup({
	-- {
	--  'ribru17/bamboo.nvim',
	--  lazy = false,
	--  priority = 1000,
	--  config = function()
	--    require('bamboo').setup {
	--      -- optional configuration here
	--    }
	--    require('bamboo').load()
	--  end,
	-- },
	{
	  "nvim-tree/nvim-tree.lua",
	  version = "*",
	  lazy = false,
	  dependencies = {
	    "nvim-tree/nvim-web-devicons",
	  },
	  config = function()
	    require("nvim-tree").setup {}
	    require("nvim-tree.api").tree.open()
	  end,
	},
	{'nvim-tree/nvim-web-devicons', config = function() require('nvim-web-devicons').setup({}) end},
	{'glepnir/nerdicons.nvim', cmd = 'NerdIcons', config = function() require('nerdicons').setup({}) end},
	{
	    'akinsho/bufferline.nvim',
	    version = "*", 
	    dependencies = 'nvim-tree/nvim-web-devicons',
	    config = function()
	      require("bufferline").setup({})
	    end,
        },
	{'f-person/git-blame.nvim'},
	{
            "FabijanZulj/blame.nvim",
            config = function()
              require("blame").setup()
            end,
        },
	{
	    "neovim/nvim-lspconfig", 
	    config = function() require("lspconfig").gopls.setup({}) end,
	},
	{
	    "nvim-lualine/lualine.nvim",
	    dependencies = { 'nvim-tree/nvim-web-devicons' },
	    config = function()
		require("lualine").setup({
		  options = {
		    icons_enabled = true,
		    theme = 'auto',
		    component_separators = { left = '', right = ''},
		    section_separators = { left = '', right = ''},
		    disabled_filetypes = {
		      statusline = {},
		      winbar = {},
		    },
		    ignore_focus = {},
		    always_divide_middle = true,
		    globalstatus = false,
		    refresh = {
		      statusline = 1000,
		      tabline = 1000,
		      winbar = 1000,
		    }
		  },
		  sections = {
		    lualine_a = {'mode'},
		    lualine_b = {'branch', 'diff', 'diagnostics'},
		    lualine_c = {'filename'},
		    lualine_x = {'encoding', 'fileformat', 'filetype'},
		    lualine_y = {'progress'},
		    lualine_z = {'location'}
		  },
		  inactive_sections = {
		    lualine_a = {},
		    lualine_b = {},
		    lualine_c = {'filename'},
		    lualine_x = {'location'},
		    lualine_y = {},
		    lualine_z = {}
		  },
		  tabline = {},
		  winbar = {},
		  inactive_winbar = {},
		  extensions = {}
		})
	    end,
        },
	{
	    'nvim-telescope/telescope.nvim', tag = '0.1.6',
	    dependencies = { 'nvim-lua/plenary.nvim' },
        },
	{"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
	{"mfussenegger/nvim-dap"},
	{ "ellisonleao/gruvbox.nvim", priority = 1000 , config = true}
})

vim.o.background = "light"  -- or "dark"
vim.cmd([[colorscheme gruvbox]])


vim.o.background = 'light'
