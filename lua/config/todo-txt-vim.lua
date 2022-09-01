--vim.cmd([[ au filetype todo setlocal omnifunc=todo#Complete ]])
--vim.cmd([[ au filetype todo imap <buffer> + +<C-X><C-O> ]])
--vim.cmd([[ au filetype todo imap <buffer> @ @<C-X><C-O> ]])
vim.g['TodoTxtUseAbbrevInsertMode'] = 1
