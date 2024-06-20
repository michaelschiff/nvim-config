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
	{
	  'ribru17/bamboo.nvim',
	  lazy = false,
	  priority = 1000,
	  config = function()
	    require('bamboo').setup {
	      -- optional configuration here
	    }
	    require('bamboo').load()
	  end,
	},
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
	{"nvim-lualine/lualine.nvim"},
})


vim.o.background = 'light'
