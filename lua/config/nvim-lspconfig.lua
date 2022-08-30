require 'lspconfig'.julials.setup {
	on_new_config = function(new_config, _)
		local julia = vim.fn.expand("~/.julia/environments/nvim-lspconfig/bin/julia")
		if require 'lspconfig'.util.path.is_file(julia) then
			new_config.cmd[1] = julia
		end
	end
}

require 'lspconfig'.r_language_server.setup({
	cmd = { 'R', '--slave', '--no-init-file', '-e', 'renv::activate(); languageserver::run()' },
	root_dir = require 'lspconfig'.util.root_pattern(".Rprofile")
})

require 'lspconfig'.sumneko_lua.setup {
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = 'LuaJIT',
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { 'vim' },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
}

require 'lspconfig'.taplo.setup {}

require 'lspconfig'.marksman.setup {
	filetypes = { 'markdown', 'pandoc' }
}

require 'lspconfig'.pylsp.setup {}
