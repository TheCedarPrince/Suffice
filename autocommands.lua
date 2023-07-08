-- Make Goyo mode as minimal as possible
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

  " Makes the signcolumn match the background colorscheme
  highlight clear SignColumn

  " Brings mode back
  set showmode 

  " Shows lualine again
  lua require"lualine".hide({unhide=true})

  " Recreate incline functionality
  lua require'incline'.setup{}

  " ...
endfunction
autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
]]
