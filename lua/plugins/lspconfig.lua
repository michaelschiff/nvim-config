return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
                        -- Go
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
                        -- Markdown
			lspconfig.marksman.setup({})
                        -- Lua
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
                        -- Bash
			lspconfig.bashls.setup({})
                        -- Terraform
			lspconfig.terraformls.setup({})
                        -- Skylark (bazel)
			lspconfig.starpls.setup({})
                        -- Python
			lspconfig.pyright.setup({})
                        -- Postgres
			lspconfig.postgres_lsp.setup({})
                        -- OpenSCAD
	 		lspconfig.openscad_lsp.setup({})
                        -- TypeSpec
			lspconfig.tsp_server.setup({})
                        -- typescript-language-server
                        lspconfig.ts_ls.setup({})
                        -- lspconfig.tsgo.setup({
                        --         cmd = {}
                        -- })
                        -- lspconfig.java_language_server.setup({
			-- 	cmd = { '/Users/michaelschiff/Documents/barista/bazel-bin/src/main/barista/barista' },
			-- 	settings = {},
			-- })
<<<<<<< Updated upstream
=======
            lspconfig.ts_ls.setup({})
			lspconfig.openscad_lsp.setup({})
			lspconfig.tsp_server.setup({})
>>>>>>> Stashed changes
		end,
	},
}
