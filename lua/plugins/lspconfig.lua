return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			lspconfig.gopls.setup({
				settings = {
					gopls = {
						analyses = {
							unusedparams = true,
						},
						staticcheck = true,
						gofumpt = true,
					},
				},
			})
			lspconfig.marksman.setup({})
			lspconfig.lua_ls.setup({
				on_init = function(client)
					client.config.settings.Lua = vim.tbl_deep_extend('force',
						client.config.settings.Lua, {
							runtime = {
								version = 'LuaJIT'
							},
							-- Make the server aware of Neovim runtime files
							workspace = {
								checkThirdParty = false,
								library = {
									vim.env.VIMRUNTIME
								}
							}
						})
				end,
				settings = {
					Lua = {}
				}
			})
			lspconfig.bashls.setup({})
			lspconfig.terraformls.setup({})
			lspconfig.starpls.setup({})
			lspconfig.pyright.setup({})
			lspconfig.postgres_lsp.setup({})
			lspconfig.java_language_server.setup({
				cmd = { '/Users/michaelschiff/Documents/barista/bazel-bin/src/main/barista/barista' },
				settings = {},
			})
			lspconfig.openscad_lsp.setup({})
			lspconfig.tsp_server.setup({})
		end,
	},
}
