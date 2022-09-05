require('neoclip').setup({
  history = 1000,
  enable_persistent_history = true,
  continious_sync = true,
  filter = nil,
  preview = true,
  default_register = '"',
  default_register_macros = 'q',
  enable_macro_history = true,
  content_spec_column = false,
  on_paste = {
    set_reg = false,
  },
  on_replay = {
    set_reg = false,
  },
  keys = {
    telescope = {
      i = {
        select = '<cr>',
        paste = '<c-p>',
        paste_behind = '<c-P>',
        replay = '<c-q>',  -- replay a macro
        delete = '<c-d>',  -- delete an entry
        custom = {},
      },
      n = {
        select = '<cr>',
        paste = 'p',
        paste_behind = 'P',
        replay = 'q',
        delete = 'd',
        custom = {},
      },
    },
    fzf = {
      select = 'default',
      paste = 'ctrl-p',
      paste_behind = 'ctrl-k',
      custom = {},
    },
  },
}
)

require('telescope').load_extension('macroscope')

function map(mode, bind, action) 
   vim.api.nvim_set_keymap(mode, bind, action .. "<cr>", { noremap = true, silent = true });
end

map("n", "<C-n>", ":Telescope neoclip")
map('n', '<A-m>', ':Telescope macroscope')
