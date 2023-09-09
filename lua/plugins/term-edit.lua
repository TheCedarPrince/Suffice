return {
    "chomosuke/term-edit.nvim",
    lazy = false, 
    config = function()
        require('term-edit').setup {
          prompt_end = '%$ '
      }
  end
}
