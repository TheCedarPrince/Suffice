require('nightfox').setup({
	options = {
		compile_path = vim.fn.stdpath("cache") .. "/nightfox", -- Default
		compile_file_suffix = "_compiled", -- Default
		transparent = false, -- Default
		terminal_colors = true, -- Default
		dim_inactive = true, -- Set non-focused panes set to different background
		styles = { -- Value is any valid attr-list value `:help attr-list`
			comments = "NONE", -- Default
			conditionals = "NONE", -- Default
			constants = "NONE", -- Default
			functions = "bold", -- Set functions to be bolded
			keywords = "NONE", -- Default
			numbers = "NONE", -- Default
			operators = "NONE", -- Default
			strings = "NONE", -- Default
			types = "underline", -- Set types to be underlined 
			variables = "NONE", -- Default
		},
		inverse = {
			match_paren = false,
			visual = true, -- Set inverse for visual mode
			search = true, -- Set inverse for search mode
		},
	}
})

-- setup must be called before loading
vim.cmd("colorscheme terafox")
