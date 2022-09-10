vim.g.goyo_width = '85%' -- Default width
vim.g.goyo_height = '90%' -- Default height

vim.cmd [[
function! s:goyo_enter()
  " Hides mode from showing
  set noshowmode 

  " Hides the sign column
  :set scl=no 

  " Hides lualine
  lua require"lualine".hide() 

  " ...
endfunction
function! s:goyo_leave()
  " Resets syntax highlighting (workaround for goyo bug)
  syntax off 
  syntax on 

  " Makes the signcolumn match the background colorscheme
  highlight clear SignColumn

  " Brings mode back
  set showmode 

  " Shows lualine again
  lua require"lualine".hide({unhide=true})

  " ...
endfunction
autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
]]
