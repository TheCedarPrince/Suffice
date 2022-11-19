---------------------------------------------------------------------------------------------
-- GLOBAL LSP AND DIAGNOSTIC SETTINGS
---------------------------------------------------------------------------------------------

local lsp_defaults = {
	flags = {
		debounce_text_changes = 150,
	},
	capabilities = require('cmp_nvim_lsp').update_capabilities(
		vim.lsp.protocol.make_client_capabilities()
	),
	on_attach = function(client, bufnr)
		vim.api.nvim_exec_autocmds('User', { pattern = 'LspAttached' })
	end
}

-- Turns off inline virtual text and makes a rounded floating border for pop-ups
vim.diagnostic.config({
	virtual_text = false,
	severity_sort = true,
	float = {
		border = 'rounded',
		source = 'always',
		header = '',
		prefix = '',
	},
})

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
	vim.lsp.handlers.hover,
	{ border = 'rounded' }
)

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
	vim.lsp.handlers.signature_help,
	{ border = 'rounded' }
)

-- Keeps diagnostics being updated while in insert mode
vim.lsp.handlers["textDocument/publishDiagnostics"] =
vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,
	{ update_in_insert = true }
)

---------------------------------------------------------------------------------------------
-- KEYMAPS FOR LSP
---------------------------------------------------------------------------------------------

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	local opts = { noremap = true, silent = true }

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	-- Displays hover information about the symbol under the cursor
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)

	-- Format file with LSP
	vim.keymap.set('n', '<C-f>', vim.lsp.buf.formatting, bufopts)

	-- Jump to the definition
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)

	-- Jump to declaration
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)

	-- Lists all the implementations for the symbol under the cursor
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)

	-- Jumps to the definition of the type symbol
	vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, bufopts)

	-- Lists all the references
	vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)

	-- Displays a function's signature information
	vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)

	-- Renames all references to the symbol under the cursor
	vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, bufopts)

	-- Selects a code action available at the current cursor position
	vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, bufopts)
	vim.keymap.set('x', '<F4>', vim.lsp.buf.range_code_action, bufopts)

	-- Show diagnostics in a floating window
	vim.keymap.set('n', 'gl', vim.diagnostic.open_float, bufopts)

	-- Move to the previous diagnostic
	vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, bufopts)

	-- Move to the next diagnostic
	vim.keymap.set('n', ']d', vim.diagnostic.goto_next, bufopts)

	-- See list of issues
	vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
end

---------------------------------------------------------------------------------------------
-- SPECIFIC LANGUAGE SERVER CONFIGURATIONS PROVIDED BY nvim-lspconfig
---------------------------------------------------------------------------------------------

require 'lspconfig'.julials.setup {
	on_new_config = function(new_config, _)
		local julia = vim.fn.expand("~/.julia/environments/nvim-lspconfig/bin/julia")
		if require 'lspconfig'.util.path.is_file(julia) then
			vim.notify("Hello!")
			new_config.cmd[1] = julia
		end
	end,
	on_attach = on_attach,
	flags = lsp_defaults
}

require 'lspconfig'.r_language_server.setup({
	on_attach = on_attach,
	flags = lsp_defaults,
	cmd = { 'R', '--slave', '--no-init-file', '-e', 'renv::activate(); languageserver::run()' },
	root_dir = function(fname)    
        	return vim.loop.cwd()
    	end,
})

require 'lspconfig'.sumneko_lua.setup {
	on_attach = on_attach,
	flags = lsp_defaults,
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

require 'lspconfig'.taplo.setup {
	on_attach = on_attach,
	flags = lsp_defaults
}

require 'lspconfig'.marksman.setup {
	on_attach = on_attach,
	flags = lsp_defaults,
	filetypes = { 'markdown', 'pandoc' }
}

require 'lspconfig'.pylsp.setup {
	on_attach = on_attach,
	flags = lsp_defaults
}

require 'lspconfig'.texlab.setup {
	on_attach = on_attach,
	flags = lsp_defaults,
	latexFormatter = 'texlab'
}
