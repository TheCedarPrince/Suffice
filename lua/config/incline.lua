require('incline').setup {
	debounce_threshold = {
		falling = 50,
		rising = 10
	},
	hide = {
		cursorline = false,
		focused_win = false,
		only_win = true -- Hide incline if only one window in tab
	},
	highlight = {
		groups = {
			InclineNormal = {
				default = true,
				group = "NormalFloat"
			},
			InclineNormalNC = {
				default = true,
				group = "NormalFloat"
			}
		}
	},
	ignore = {
		buftypes = "special",
		filetypes = {},
		floating_wins = true,
		unlisted_buffers = true,
		wintypes = "special"
	},
	render = function(props)
		local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
		local colors = require('gruvbox.palette')

		if props.focused == true then
			return {
				{
					fname,
					guibg = colors.dark0_hard,
					guifg = colors.light1
				}
			}
		else
			return {
				{
					fname,
					guibg = colors.dark0_hard,
					guifg = colors.dark4
				}
			}
		end
	end,
	window = {
		margin = {
			horizontal = 1,
			vertical = 2
		},
		options = {
			signcolumn = "no",
			wrap = false
		},
		padding = 0,
		padding_char = " ",
		placement = {
			horizontal = "right",
			vertical = "top"
		},
		width = "fit",
		winhighlight = {
			active = {
				EndOfBuffer = "None",
				Normal = "InclineNormal",
				Search = "None"
			},
			inactive = {
				EndOfBuffer = "None",
				Normal = "InclineNormalNC",
				Search = "None"
			}
		},
		zindex = 50
	}
}
