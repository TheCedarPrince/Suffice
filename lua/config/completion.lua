local cmp = require("cmp")
local luasnip = require("luasnip")

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

-- Initialize Luasnip completions
require("luasnip/loaders/from_vscode").lazy_load()
require("luasnip/loaders/from_snipmate").lazy_load({ paths = {"~/.config/nvim/snippets"} })

-- Fallback function for completion when hitting backspace
local check_backspace = function()
	local col = vim.fn.col(".") - 1
	return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

-- Create icons for autocompletion types
local kind_icons = {
	Text = "",
	Method = "",
	Function = "",
	Constructor = "",
	Field = "",
	Variable = "",
	Class = "",
	Interface = "",
	Module = "",
	Property = "",
	Unit = "",
	Value = "",
	Enum = "",
	Keyword = "",
	Snippet = "✂",
	Color = "",
	File = "",
	Reference = "",
	Folder = "",
	EnumMember = "",
	Constant = "",
	Struct = "",
	Event = "",
	Operator = "",
	TypeParameter = "",
}

cmp.setup({
	-- Snippet engine 
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body) -- For `luasnip` users.
		end,
	},

	-- Keymaps for autocompletion
	mapping = cmp.mapping.preset.insert({
		-- Goes up list of completions
		["<C-k>"] = cmp.mapping.select_prev_item(),

		-- Goes down list of completions
		["<C-j>"] = cmp.mapping.select_next_item(),

		-- Goes up definition of a completion
		["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),

		-- Goes down definition of a completion
		["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),

		-- Starts autocompletion engine
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),

		-- Aborts autocomption selection process
		["<C-e>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),

		-- Accept currently selected item. If none selected, `select` first item.
		-- Set `select` to `false` to only confirm explicitly selected items.
		["<CR>"] = cmp.mapping.confirm({ select = true }),

		-- Set what tab does
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expandable() then
				luasnip.expand()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif check_backspace() then
				fallback()
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
	}),

	-- Formatting for autocompletion menu
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
			vim_item.kind = kind_icons[vim_item.kind]
			vim_item.menu = ({
				nvim_lsp = "",
				nvim_lua = "",
				luasnip = "",
				buffer = "",
				path = "",
				emoji = "",
				["vim-dadbod-completion"] = "[DB]",
			})[entry.source.name]
			return vim_item
		end,
	},

	-- Sources available for autocompletion
	sources = {
		{ name = "nvim_lsp" },
		{ name = "nvim_lua" },
		{ name = "luasnip" },
		{ name = "buffer"},
		{ name = "path" },
    		{ name = "vim-dadbod-completion" }
	},

	-- Options for confirmation
	confirm_opts = {
		behavior = cmp.ConfirmBehavior.Replace,
		select = false,
	},

	-- Configuration for completion window
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},

	-- Experimental configurations
	experimental = {
		ghost_text = true,
	},
})
