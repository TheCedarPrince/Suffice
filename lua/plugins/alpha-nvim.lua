return {
  "goolord/alpha-nvim",
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  lazy = false,
  config = function()

local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- Set header
dashboard.section.header.val = {
     '                                                      ',	  
     ' ███████╗██╗   ██╗███████╗███████╗██╗ ██████╗███████╗ ',
     ' ██╔════╝██║   ██║██╔════╝██╔════╝██║██╔════╝██╔════╝ ',
     ' ███████╗██║   ██║█████╗  █████╗  ██║██║     █████╗   ',
     ' ╚════██║██║   ██║██╔══╝  ██╔══╝  ██║██║     ██╔══╝   ',
     ' ███████║╚██████╔╝██║     ██║     ██║╚██████╗███████╗ ',
     ' ╚══════╝ ╚═════╝ ╚═╝     ╚═╝     ╚═╝ ╚═════╝╚══════╝ ',
     '                                                      ',	  
}

dashboard.section.header.opts.hl = ""

-- Set menu
dashboard.section.buttons.val = {
    dashboard.button( "e", "  > New file" , ":ene <BAR> startinsert <CR>"),
    dashboard.button( "f", "  > Find file", ":cd $HOME/Workspace | Telescope find_files<CR>"),
    dashboard.button( "r", "  > Recent"   , ":Telescope oldfiles<CR>"),
    dashboard.button( "s", "  > Settings" , ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"),
    dashboard.button( "q", "  > Quit NVIM", ":qa<CR>"),
}

-- Send config to alpha
alpha.setup(dashboard.opts)

vim.api.nvim_create_autocmd("FileType", {
    command = [[setlocal buflisted fillchars=eob:\ ]],
    desc = "Fix buffer movement, remove eob in alpha.",
    group = group,
    pattern = "alpha",
})

vim.cmd([[
    autocmd FileType alpha setlocal nofoldenable
    autocmd User AlphaReady set laststatus=0 | autocmd BufUnload <buffer> set laststatus=3
]])

local alpha_start_group = vim.api.nvim_create_augroup("AlphaStart", { clear = true })
vim.api.nvim_create_autocmd("TabNewEntered", {
    callback = function()
        alpha.start()
    end,
    group = alpha_start_group,
})

end
}
