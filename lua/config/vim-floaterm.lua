function map(mode, bind, action) 
   vim.api.nvim_set_keymap(mode, bind, action .. "<cr>", { noremap = true, silent = true });
end

map("n", "<A-w>", ":FloatermNew --wintype=split --height=0.4 --position=bottom --autoclose=2")
map("i", "<A-t>", "<C-c>:FloatermToggle<CR>")
map("n", "<A-t>", "<C-c>:FloatermToggle<CR>")
map("t", "<A-t>", "<C-\\><C-n>:FloatermToggle<CR>")
map("t", "<A-p>", "<C-\\><C-n>:FloatermPrev<CR>")
map("n", "<A-p>", ":FloatermPrev<CR>")
map("t", "<A-n>", "<C-\\><C-n>:FloatermNext<CR>")
map("n", "<A-n>", ":FloatermNext<CR>")
map("t", "<A-q>", "<C-\\><C-n>")
map("n", "<A-c>", ":FloatermSend<CR>")
map("v", "<A-c>", ":FloatermSend<CR>")
