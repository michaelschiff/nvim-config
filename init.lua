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


vim.g.mapleader = " "       -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.maplocalleader = "\\" -- Same for `maplocalleader`

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true
vim.opt.number = true

require("lazy").setup({
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
	{ 'nvim-tree/nvim-web-devicons', config = function() require('nvim-web-devicons').setup({}) end },
	{
		'glepnir/nerdicons.nvim',
		cmd = 'NerdIcons',
		config = function()
			require('nerdicons').setup({})
		end
	},
	{
		'akinsho/bufferline.nvim',
		version = "*",
		dependencies = 'nvim-tree/nvim-web-devicons',
		config = function()
			require("bufferline").setup({})
		end,
	},
	{ 'f-person/git-blame.nvim' },
	{
		"FabijanZulj/blame.nvim",
		config = function()
			require("blame").setup()
		end,
	},
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
								-- Tell the language server which version of Lua you're using
								-- (most likely LuaJIT in the case of Neovim)
								version = 'LuaJIT'
							},
							-- Make the server aware of Neovim runtime files
							workspace = {
								checkThirdParty = false,
								library = {
									vim.env.VIMRUNTIME
									-- Depending on the usage, you might want to add additional paths here.
									-- "${3rd}/luv/library"
									-- "${3rd}/busted/library",
								}
								-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
								-- library = vim.api.nvim_get_runtime_file("", true)
							}
						})
				end,
				settings = {
					Lua = {}
				}
			})
			lspconfig.bashls.setup({})
			lspconfig.terraformls.setup({})
		end,
	},
	{
		"mfussenegger/nvim-jdtls",
		config = function()
			local home = os.getenv('HOME')
			local jdtls = require('jdtls')

			-- File types that signify a Java project's root directory. This will be
			-- used by eclipse to determine what constitutes a workspace
			local root_markers = { 'maven_install.json' }
			local root_dir = require('jdtls.setup').find_root(root_markers)

			-- eclipse.jdt.ls stores project specific data within a folder. If you are working
			-- with multiple different projects, each project must use a dedicated data directory.
			-- This variable is used to configure eclipse to use the directory name of the
			-- current project found using the root_marker as the folder for project specific data.
			local workspace_folder = home ..
			"/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

			-- Helper function for creating keymaps
			local function nnoremap(rhs, lhs, bufopts, desc)
				bufopts.desc = desc
				vim.keymap.set("n", rhs, lhs, bufopts)
			end

			-- The on_attach function is used to set key maps after the language server
			-- attaches to the current buffer
			local on_attach = function(client, bufnr)
				-- Regular Neovim LSP client keymappings
				local bufopts = { noremap = true, silent = true, buffer = bufnr }
				nnoremap('gD', vim.lsp.buf.declaration, bufopts, "Go to declaration")
				nnoremap('gd', vim.lsp.buf.definition, bufopts, "Go to definition")
				nnoremap('gi', vim.lsp.buf.implementation, bufopts, "Go to implementation")
				nnoremap('K', vim.lsp.buf.hover, bufopts, "Hover text")
				nnoremap('<C-k>', vim.lsp.buf.signature_help, bufopts, "Show signature")
				nnoremap('<space>wa', vim.lsp.buf.add_workspace_folder, bufopts, "Add workspace folder")
				nnoremap('<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts,
					"Remove workspace folder")
				nnoremap('<space>wl', function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, bufopts, "List workspace folders")
				nnoremap('<space>D', vim.lsp.buf.type_definition, bufopts, "Go to type definition")
				nnoremap('<space>rn', vim.lsp.buf.rename, bufopts, "Rename")
				nnoremap('<space>ca', vim.lsp.buf.code_action, bufopts, "Code actions")
				vim.keymap.set('v', "<space>ca", "<ESC><CMD>lua vim.lsp.buf.range_code_action()<CR>",
					{ noremap = true, silent = true, buffer = bufnr, desc = "Code actions" })
				nnoremap('<space>f', function() vim.lsp.buf.format { async = true } end, bufopts,
					"Format file")

				-- Java extensions provided by jdtls
				nnoremap("<C-o>", jdtls.organize_imports, bufopts, "Organize imports")
				nnoremap("<space>ev", jdtls.extract_variable, bufopts, "Extract variable")
				nnoremap("<space>ec", jdtls.extract_constant, bufopts, "Extract constant")
				vim.keymap.set('v', "<space>em",
					[[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
					{ noremap = true, silent = true, buffer = bufnr, desc = "Extract method" })
			end

			local config = {
				flags = {
					debounce_text_changes = 80,
				},
				on_attach = on_attach, -- We pass our on_attach keybindings to the configuration map
				root_dir = root_dir, -- Set the root directory to our found root_marker
				-- Here you can configure eclipse.jdt.ls specific settings
				-- These are defined by the eclipse.jdt.ls project and will be passed to eclipse when starting.
				-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
				-- for a list of options
				settings = {
					java = {
						format = {
							settings = {
								-- Use Google Java style guidelines for formatting
								-- To use, make sure to download the file from https://github.com/google/styleguide/blob/gh-pages/eclipse-java-google-style.xml
								-- and place it in the ~/.local/share/eclipse directory
								url =
								"/.local/share/eclipse/eclipse-java-google-style.xml",
								profile = "GoogleStyle",
							},
						},
						signatureHelp = { enabled = true },
						contentProvider = { preferred = 'fernflower' }, -- Use fernflower to decompile library code
						-- Specify any completion options
						completion = {
							favoriteStaticMembers = {
								"org.hamcrest.MatcherAssert.assertThat",
								"org.hamcrest.Matchers.*",
								"org.hamcrest.CoreMatchers.*",
								"org.junit.jupiter.api.Assertions.*",
								"java.util.Objects.requireNonNull",
								"java.util.Objects.requireNonNullElse",
								"org.mockito.Mockito.*"
							},
							filteredTypes = {
								"com.sun.*",
								"io.micrometer.shaded.*",
								"java.awt.*",
								"jdk.*", "sun.*",
							},
						},
						-- Specify any options for organizing imports
						sources = {
							organizeImports = {
								starThreshold = 9999,
								staticStarThreshold = 9999,
							},
						},
						-- How code generation should act
						codeGeneration = {
							toString = {
								template =
								"${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
							},
							hashCodeEquals = {
								useJava7Objects = true,
							},
							useBlocks = true,
						},
						-- If you are developing in projects with different Java versions, you need
						-- to tell eclipse.jdt.ls to use the location of the JDK for your Java version
						-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
						-- And search for `interface RuntimeOption`
						-- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
						configuration = {
							runtimes = {
								{
									name = "JavaSE-17",
									path = "/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home",
								},
								{
									name = "JavaSE-11",
									path = "/Library/Java/JavaVirtualMachines/zulu-11.jdk/Contents/Home",
								},
								{
									name = "JavaSE-1.8",
									path = "/Users/michaelschiff/Library/Java/JavaVirtualMachines/azul-18.0.1/Contents/Home"
								},
							}
						}
					}
				},
				-- cmd is the command that starts the language server. Whatever is placed
				-- here is what is passed to the command line to execute jdtls.
				-- Note that eclipse.jdt.ls must be started with a Java version of 17 or higher
				-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
				-- for the full list of options
				cmd = {
					"java",
					'-Declipse.application=org.eclipse.jdt.ls.core.id1',
					'-Dosgi.bundles.defaultStartLevel=4',
					'-Declipse.product=org.eclipse.jdt.ls.core.product',
					'-Dlog.protocol=true',
					'-Dlog.level=ALL',
					'-Xmx4g',
					'--add-modules=ALL-SYSTEM',
					'--add-opens', 'java.base/java.util=ALL-UNNAMED',
					'--add-opens', 'java.base/java.lang=ALL-UNNAMED',
					-- The jar file is located where jdtls was installed. This will need to be updated
					-- to the location where you installed jdtls
					'-jar', vim.fn.glob(
					'/opt/homebrew/Cellar/jdtls/1.36.0/libexec/plugins/org.eclipse.equinox.launcher_*.jar'),

					-- The configuration for jdtls is also placed where jdtls was installed. This will
					-- need to be updated depending on your environment
					'-configuration', '/opt/homebrew/Cellar/jdtls/1.36.0/libexec/config_mac',

					-- Use the workspace_folder defined above to store data for this project
					'-data', workspace_folder,
				},
			}

			-- Finally, start jdtls. This will run the language server using the configuration we specified,
			-- setup the keymappings, and attach the LSP client to the current buffer
			jdtls.start_or_attach(config)
		end
	},
	{ "windwp/nvim-autopairs",           config = function() require("nvim-autopairs").setup({}) end },
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/vim-vsnip"
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					-- REQUIRED - you must specify a snippet engine
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
						-- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
						-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
						-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
						-- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					['<C-b>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-e>'] = cmp.mapping.abort(),
					['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				}),
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
					{ name = 'vsnip' }, -- For vsnip users.
					-- { name = 'luasnip' }, -- For luasnip users.
					-- { name = 'ultisnips' }, -- For ultisnips users.
					-- { name = 'snippy' }, -- For snippy users.
				}, {
					{ name = 'buffer' },
				})
			})
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = 'auto',
					component_separators = { left = '', right = '' },
					section_separators = { left = '', right = '' },
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
					lualine_a = { 'mode' },
					lualine_b = { 'branch', 'diff', 'diagnostics' },
					lualine_c = { 'filename' },
					lualine_x = { 'encoding', 'fileformat', 'filetype' },
					lualine_y = { 'progress' },
					lualine_z = { 'location' }
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { 'filename' },
					lualine_x = { 'location' },
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
		'nvim-telescope/telescope.nvim',
		tag = '0.1.6',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			local builtin = require('telescope.builtin')
			vim.keymap.set('n', '<C-f><C-f>', builtin.find_files, {})
			vim.keymap.set('n', '<C-n>', builtin.lsp_references, {})
			vim.keymap.set('n', '<C-j>', builtin.lsp_incoming_calls, {})
			vim.keymap.set('n', '<C-m>', vim.lsp.buf.definition, {})
			vim.keymap.set('n', '<M-LeftMouse>', vim.lsp.buf.definition, {})
			vim.keymap.set('n', '<C-i>', vim.lsp.buf.implementation, {})
			vim.keymap.set('n', '<C-o>', vim.lsp.buf.document_symbol, {})
		end,
	},
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	{ "mfussenegger/nvim-dap" },
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = function()
			require("gruvbox").setup({
				terminal_colors = true, -- add neovim terminal colors
				undercurl = true,
				underline = true,
				bold = true,
				italic = {
					strings = true,
					emphasis = true,
					comments = true,
					operators = false,
					folds = true,
				},
				strikethrough = true,
				invert_selection = false,
				invert_signs = false,
				invert_tabline = false,
				invert_intend_guides = false,
				inverse = true, -- invert background for search, diffs, statuslines and errors
				contrast = "hard", -- can be "hard", "soft" or empty string
				palette_overrides = {},
				overrides = {},
				dim_inactive = false,
				transparent_mode = false,
			})
		end
	},
	{
		dir = "/Users/michaelschiff/Documents/nvim-todo",
		config = function()
			require("todo").setup({
				name = "michael",
				tokenPath =
				"/Users/michaelschiff/Desktop/test.txt"
			})
		end
	},
})

--vim.api.nvim_create_augroup('AutoFormatting', {})
--vim.api.nvim_create_autocmd('BufWritePre', {
--	pattern = '*',
--	group = 'AutoFormatting',
--	callback = function() vim.cmd("gggqG") end,
--})
--
vim.o.background = "light" -- or "dark"
vim.cmd([[colorscheme gruvbox]])
