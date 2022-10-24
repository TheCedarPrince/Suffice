vim.g['pandoc#filetypes#handled'] = {'pandoc', 'markdown'} -- When to activate pandoc
vim.g['pandoc#modules#disabled'] = {'folding', 'toc', 'templates', 'yaml'} -- What pandoc modules to disable
vim.g['pandoc#biblio#bibs'] = {'/home/src/Knowledgebase/Zettelkasten/zettel.bib', '/home/src/Projects/C3T/citations.bib'} -- Sources for bibliography citations
vim.g['pandoc#completion#bib#use_preview'] = 1 -- Display additional bibliographic information in a preview window
vim.g['pandoc#completion#bib#mode'] = 'citeproc' -- What backend to use
vim.g['pandoc#hypertext#split_open_cmd'] = 'vsplit' -- How to split-open files
vim.g['pandoc#hypertext#autosave_on_edit_open_link'] = 1 -- Automatically save current file when following link in same window
vim.g['pandoc#syntax#codeblocks#embeds#langs'] = {'json', 'julia', 'python', 'haskell', 'r', 'tex', 'markdown', 'lua', 'make', 'sh', 'sql'} -- Syntax highlighting for fenced markdown code blocks 
