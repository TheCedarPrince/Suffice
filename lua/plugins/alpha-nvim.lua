return {
  "goolord/alpha-nvim",
  commit = "6c6a89d5b068b5251c8bdf0dd57bb921bcfeeb09",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false,
  config = function()

    local alpha     = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- ── Header ────────────────────────────────────────────────────────────
    dashboard.section.header.val = {
      '',
      '',
      '',
' █████╗ ██████╗ ██╗   ██╗███╗   ██╗██████╗  █████╗ ███╗   ██╗ ██████╗███████╗',
'██╔══██╗██╔══██╗██║   ██║████╗  ██║██╔══██╗██╔══██╗████╗  ██║██╔════╝██╔════╝',
'███████║██████╔╝██║   ██║██╔██╗ ██║██║  ██║███████║██╔██╗ ██║██║     █████╗  ',
'██╔══██║██╔══██╗██║   ██║██║╚██╗██║██║  ██║██╔══██║██║╚██╗██║██║     ██╔══╝  ',
'██║  ██║██████╔╝╚██████╔╝██║ ╚████║██████╔╝██║  ██║██║ ╚████║╚██████╗███████╗',
'╚═╝  ╚═╝╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝╚══════╝'

    }
    dashboard.section.header.opts.hl = ""

    -- ── Helpers ───────────────────────────────────────────────────────────
    local function pad_right(text, width)
      local len = vim.fn.strdisplaywidth(text)
      if len >= width then return text end
      return text .. string.rep(" ", width - len)
    end

    local COL_W = 30

    local function grid_line(left, right)
      return " " .. pad_right(left, COL_W) .. " | " .. pad_right(right, COL_W)
    end

    local function grid_border(l, r, m)
      return " " .. l .. string.rep("─", COL_W + 1) .. m .. string.rep("─", COL_W + 1) .. r
    end

    -- ── Git info (expanded) ───────────────────────────────────────────────
    -- Returns a list of display lines for the git summary block.
    -- Shows: branch + clean/dirty, unstaged count, last 3 commits.
    local function git_info_lines()
      local branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("\n", "")
      if branch == "" then return {} end

      local lines = {}

      -- Branch + dirty marker
      local porcelain = vim.fn.system("git status --porcelain 2>/dev/null")
      local is_dirty  = porcelain ~= ""
      local marker    = is_dirty and " ●" or " ✓"
      table.insert(lines, "   " .. branch .. marker)

      -- Unstaged / staged counts
      if is_dirty then
        local unstaged = 0
        local staged   = 0
        for line in porcelain:gmatch("[^\n]+") do
          local xy = line:sub(1, 2)
          if xy:sub(2, 2) ~= " " then unstaged = unstaged + 1 end
          if xy:sub(1, 1) ~= " " and xy:sub(1, 1) ~= "?" then staged = staged + 1 end
        end
        local parts = {}
        if staged   > 0 then table.insert(parts, staged   .. " staged") end
        if unstaged > 0 then table.insert(parts, unstaged .. " unstaged") end
        if #parts > 0 then
          table.insert(lines, "   " .. table.concat(parts, "  ·  "))
        end
      end

      -- Last 3 commits: hash  subject  (relative date)
      local log = vim.fn.systemlist(
        "git log --oneline --pretty=format:'%C(auto)%h  %s  (%cr)' -3 2>/dev/null"
      )
      if #log > 0 then
        table.insert(lines, "")   -- blank separator
        for _, entry in ipairs(log) do
          table.insert(lines, "   " .. entry)
        end
      end

      return lines
    end

    local git_lines = git_info_lines()
    local git_val   = {}
    for _, l in ipairs(git_lines) do
      table.insert(git_val, { type = "text", val = l, opts = { position = "center", hl = "Comment" } })
    end
    if #git_val > 0 then
      table.insert(git_val, { type = "padding", val = 1 })
    end

    local git_section = {
      type = "group",
      val  = git_val,
      opts = { spacing = 0 },
    }

    -- ── Command grid ──────────────────────────────────────────────────────
    local command_grid = {
      type = "group",
      val  = {
        { type = "text", val = grid_border("┌", "┐", "┬"), opts = { position = "center", hl = "Comment" } },
        { type = "text", val = grid_line("[s] Select Workspace", "[b] Browse Files"),  opts = { position = "center", hl = "Comment" } },
        { type = "text", val = grid_line("[r] Recent Files",     "[g] Live Grep"),      opts = { position = "center", hl = "Comment" } },
        { type = "text", val = grid_line("[c] Neovim Config",    "[t] Floaterm"),        opts = { position = "center", hl = "Comment" } },
        { type = "text", val = grid_line("[q] Quit",             ""),                   opts = { position = "center", hl = "Comment" } },
        { type = "text", val = grid_border("└", "┘", "┴"), opts = { position = "center", hl = "Comment" } },
      },
      opts = { spacing = 0 },
    }

    -- ── Workspace list ────────────────────────────────────────────────────
    -- Read workspace names from the .cs_workspaces file.
    -- CtrlSpace stores them relative to the project root (CWD).
    local function get_workspaces()
      local ws_dir  = vim.fn.getcwd()
      local ws_file = ws_dir .. "/.cs_workspaces"
      local names   = {}
      local f       = io.open(ws_file, "r")
      if f then
        for line in f:lines() do
          local name = line:match("CS_WORKSPACE_BEGIN:%s*(.-)%s*$")
          if name and name ~= "" then
            table.insert(names, name)
          end
        end
        f:close()
      end
      return names
    end

    local workspaces = get_workspaces()

    local ws_keys = {}
    for i = 1, 9 do ws_keys[i] = tostring(i) end
    for _, k in ipairs({ "a","b","c","d","e","f","h","i","j","k","l","m",
                         "n","o","p","u","v","w","x","y","z" }) do
      table.insert(ws_keys, k)
    end

    local ws_grid_lines = {
      { type = "text", val = grid_border("┌", "┐", "┬"), opts = { position = "center", hl = "Comment" } },
    }
    for i = 1, #workspaces, 2 do
      local lname = workspaces[i]
      local rname = workspaces[i + 1]
      local lkey  = ws_keys[i]     or "?"
      local rkey  = ws_keys[i + 1] or ""
      local left  = "[" .. lkey .. "] " .. lname
      local right = rname and ("[" .. rkey .. "] " .. rname) or ""
      table.insert(ws_grid_lines, {
        type = "text",
        val  = grid_line(left, right),
        opts = { position = "center", hl = "Comment" },
      })
    end
    table.insert(ws_grid_lines, {
      type = "text",
      val  = grid_border("└", "┘", "┴"),
      opts = { position = "center", hl = "Comment" },
    })

    local workspace_grid = {
      type = "group",
      val  = ws_grid_lines,
      opts = { spacing = 0 },
    }

    -- ── Footer: recent project files ──────────────────────────────────────
    local function recent_project_files()
      local files = vim.fn.systemlist(
        "git ls-files --others --exclude-standard --cached 2>/dev/null | xargs ls -t 2>/dev/null | head -5"
      )
      if #files == 0 then return { "  (no project files found)" } end
      local result = {}
      for _, f in ipairs(files) do table.insert(result, "  " .. f) end
      return result
    end

    dashboard.section.footer.val = recent_project_files()
    dashboard.section.footer.opts.hl = "Comment"

    -- ── Layout ────────────────────────────────────────────────────────────
    dashboard.config.layout = {
      { type = "padding", val = 2 },
      dashboard.section.header,
      { type = "padding", val = 2 },
      git_section,
      command_grid,
      { type = "padding", val = 1 },
      workspace_grid,
      { type = "padding", val = 1 },
      dashboard.section.footer,
    }

    alpha.setup(dashboard.config)

    -- ── Keymaps ───────────────────────────────────────────────────────────
    -- Workspace loading fix: CtrlSpaceLoadWorkspace passes name as a bare
    -- command string, which splits on spaces. Workspace names with spaces
    -- (e.g. "Compassionate Systems") break because the command sees two
    -- separate arguments. The fix is to call the underlying vimscript
    -- function ctrlspace#workspaces#LoadWorkspace() directly via vim.fn,
    -- which passes the name as a proper Lua string with no shell-splitting.
    local function load_workspace(name)
      local ok, err = pcall(vim.fn["ctrlspace#workspaces#LoadWorkspace"], 0, name)
      if not ok then
        vim.notify("CtrlSpace: could not load workspace '" .. name .. "'\n" .. tostring(err),
          vim.log.levels.ERROR)
      end
    end

    local function map_keys(bufnr)
      local opts = { buffer = bufnr, noremap = true, silent = true, nowait = true }
      vim.keymap.set("n", "s", "<cmd>CtrlSpace<CR>",                                                opts)
      vim.keymap.set("n", "b", "<cmd>FzfLua files<CR>",                                             opts)
      vim.keymap.set("n", "r", "<cmd>FzfLua oldfiles<CR>",                                          opts)
      vim.keymap.set("n", "g", "<cmd>FzfLua live_grep<CR>",                                         opts)
      vim.keymap.set("n", "c", "<cmd>e $MYVIMRC | cd %:p:h | split . | wincmd k | pwd<CR>",         opts)
      vim.keymap.set("n", "t", "<cmd>FloatermNew --height=0.4 --position=bottom --wintype=split<CR>", opts)
      vim.keymap.set("n", "q", "<cmd>qa<CR>",                                                        opts)

      for i, name in ipairs(workspaces) do
        local key = ws_keys[i]
        if key then
          -- Capture name in closure explicitly to avoid the classic loop-variable bug
          local ws_name = name
          vim.keymap.set("n", key, function()
            load_workspace(ws_name)
          end, opts)
        end
      end
    end

    -- ── Autocmds ──────────────────────────────────────────────────────────
    local group = vim.api.nvim_create_augroup("AlphaDashboard", { clear = true })

    vim.api.nvim_create_autocmd("FileType", {
      group   = group,
      pattern = "alpha",
      command = [[setlocal buflisted fillchars=eob:\ ]],
    })

    vim.api.nvim_create_autocmd("FileType", {
      group    = group,
      pattern  = "alpha",
      callback = function() vim.opt_local.foldenable = false end,
    })

    vim.api.nvim_create_autocmd("User", {
      group    = group,
      pattern  = "AlphaReady",
      callback = function()
        vim.opt.laststatus = 0
        vim.api.nvim_create_autocmd("BufUnload", {
          buffer   = 0,
          once     = true,
          callback = function() vim.opt.laststatus = 3 end,
        })
      end,
    })

    vim.api.nvim_create_autocmd("TabNewEntered", {
      group    = group,
      callback = function()
        if vim.g.goyo_id then return end
        local buf   = vim.api.nvim_get_current_buf()
        local name  = vim.api.nvim_buf_get_name(buf)
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        if name == "" and #lines == 1 and lines[1] == "" then
          alpha.start()
        end
      end,
    })

    vim.api.nvim_create_autocmd({ "FileType", "User" }, {
      group    = group,
      pattern  = { "alpha", "AlphaReady" },
      callback = function(ev)
        local buf = ev.buf or vim.api.nvim_get_current_buf()
        if vim.bo[buf].filetype == "alpha" then
          map_keys(buf)
        end
      end,
    })

  end,
}
