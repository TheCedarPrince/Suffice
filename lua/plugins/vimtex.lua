return {
  "lervag/vimtex",
  lazy = false,
  config = function()
    -- ── Viewer & compiler ─────────────────────────────────────────────────
    vim.g.vimtex_view_general_viewer = "zathura"
    vim.g.vimtex_compiler_method     = "latexmk"
    vim.g.vimtex_compiler_latexmk = {
      options = {
        "-lualatex",
        "-bibtex",
        "-shell-escape",
        "-verbose",
        "-file-line-error",
        "-synctex=1",
        "-interaction=nonstopmode",
      },
    }
    -- ── Folding ───────────────────────────────────────────────────────────
    vim.g.vimtex_fold_enabled = 1
    vim.g.vimtex_fold_types = {
      sections = { parse_levels = 1 },
      envs     = { 
	      enabled = 1,
              blacklist = {'enumerate'},
      },
      preamble = { enabled = 1 },
      comments = { enabled = 0 },
      items    = { enabled = 1 },
    }
    -- ── Conceal ───────────────────────────────────────────────────────────
    vim.g.vimtex_syntax_conceal = {
      accents         = 1,
      ligatures       = 1,
      cites           = 1,
      fancy           = 1,
      greek           = 1,
      math_bounds     = 1,
      math_delimiters = 1,
      math_fracs      = 1,
      math_super_sub  = 1,
      math_symbols    = 1,
      sections        = 1,
      styles          = 1,
    }

    -- ── Shared conceal helper (also used by Goyo) ─────────────────────────
    _G.apply_tex_conceal = function()
      vim.opt_local.conceallevel  = 2
      vim.opt_local.concealcursor = "nc"
      vim.fn.matchadd("Conceal", [[\\\(begin\|end\){[^}]*}]], 10, -1, { conceal = "" })
      vim.fn.matchadd("Conceal", [[\\item]], 10, -1)
    end

    -- ── Per-buffer tex settings ───────────────────────────────────────────
    vim.api.nvim_create_autocmd("FileType", {
      pattern  = "tex",
      callback = function()
        -- Folding
        vim.opt_local.foldmethod     = "expr"
        vim.opt_local.foldexpr       = "vimtex#fold#level(v:lnum)"
        vim.opt_local.foldtext       = "vimtex#fold#text()"
        vim.opt_local.foldlevel      = 2
        vim.opt_local.foldlevelstart = 2
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        for i, line in ipairs(lines) do
          if line:match("^\\documentclass") then
            vim.cmd(i .. "foldclose")
            break
          end
        end
        -- Conceal
        _G.apply_tex_conceal()
      end,
    })
    -- ── Reduce UI noise ───────────────────────────────────────────────────
    vim.g.vimtex_quickfix_mode              = 2
    vim.g.vimtex_quickfix_autoclose_on_quit = 1
    vim.g.vimtex_status_force               = 1
    vim.g.vimtex_log_ignore = {
      "Underfull",
      "Overfull",
      "specifier changed to",
      "Token not allowed in a PDF string",
    }
    -- ── Misc ──────────────────────────────────────────────────────────────
    vim.g.vimtex_imaps_enabled         = 0
    vim.g.vimtex_complete_close_braces = 1
    vim.g.vimtex_syntax_enabled        = 1
    vim.g.vimtex_indent_on_ampersands  = 0
  end,
}
