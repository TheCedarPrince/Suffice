return {
  "JuliaEditorSupport/julia-vim",
  lazy = false,
  config = function()
    vim.g.latex_to_unicode_tab = "off"
    vim.g.latex_to_unicode_auto = 1
  end
}
