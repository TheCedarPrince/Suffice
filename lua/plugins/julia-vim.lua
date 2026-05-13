-- ~/.config/nvim/lua/plugins/julia-vim.lua

return {
  "JuliaEditorSupport/julia-vim",
  commit = "52b30547346b21bc93acda28d626795667f9e087",
  lazy = false,
  config = function()
    -- LaTeX-to-Unicode (tab completion stays on, auto-replace on)
    vim.g.latex_to_unicode_tab  = "on"
    vim.g.latex_to_unicode_auto = 1

    -- Block-jumping keymaps (only active in Julia buffers)
    local jump_maps = {
      { "]}", "][", "Next end of block"       },
      { "[{", "[[", "Previous start of block" },
      { "[}", "[]", "Previous end of block"   },
      { "]{", "]]", "Next start of block"     },
    }

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "julia",
      callback = function(ev)
        local buf = ev.buf
        local opts = { buffer = buf, silent = true }

        for _, m in ipairs(jump_maps) do
          local lhs, rhs, desc = m[1], m[2], m[3]
          -- normal + operator-pending so e.g. d[[ works
          vim.keymap.set({ "n", "o" }, lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
        end

        -- which-key group + descriptions (buffer-local)
        local ok, wk = pcall(require, "which-key")
        if not ok then return end

        wk.add({
          -- <leader>j group label (shown in the popup)
          { "<leader>j", group = "Julia", buffer = buf },

          -- Block navigation sub-group
          { "<leader>jb", group = "Block jump", buffer = buf },
          { "<leader>jb]", "][", desc = "Next end of block",       buffer = buf, mode = "n" },
          { "<leader>jb[", "[[", desc = "Prev start of block",     buffer = buf, mode = "n" },
          { "<leader>jbp", "[]", desc = "Prev end of block",       buffer = buf, mode = "n" },
          { "<leader>jbn", "]]", desc = "Next start of block",     buffer = buf, mode = "n" },
        })
      end,
    })
  end,
}
