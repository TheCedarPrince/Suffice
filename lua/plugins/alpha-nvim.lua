return {
  "goolord/alpha-nvim",
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  lazy = false,
  config = function()

local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- Set header
dashboard.section.header.val = {
	'',
	'',
	'',
	'███████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████',
	'█▌                                                                                                                           ▐█',
	'█▌    █████████   ███████████  █████  █████ ██████   █████ ██████████     █████████   ██████   █████   █████████  ██████████ ▐█',
	'█▌   ███░░░░░███ ░░███░░░░░███░░███  ░░███ ░░██████ ░░███ ░░███░░░░███   ███░░░░░███ ░░██████ ░░███   ███░░░░░███░░███░░░░░█ ▐█',
	'█▌  ░███    ░███  ░███    ░███ ░███   ░███  ░███░███ ░███  ░███   ░░███ ░███    ░███  ░███░███ ░███  ███     ░░░  ░███  █ ░  ▐█',
	'█▌  ░███████████  ░██████████  ░███   ░███  ░███░░███░███  ░███    ░███ ░███████████  ░███░░███░███ ░███          ░██████    ▐█',
	'█▌  ░███░░░░░███  ░███░░░░░███ ░███   ░███  ░███ ░░██████  ░███    ░███ ░███░░░░░███  ░███ ░░██████ ░███          ░███░░█    ▐█',
	'█▌  ░███    ░███  ░███    ░███ ░███   ░███  ░███  ░░█████  ░███    ███  ░███    ░███  ░███  ░░█████ ░░███     ███ ░███ ░   █ ▐█',
	'█▌  █████   █████ ███████████  ░░████████   █████  ░░█████ ██████████   █████   █████ █████  ░░█████ ░░█████████  ██████████ ▐█',
	'█▌ ░░░░░   ░░░░░ ░░░░░░░░░░░    ░░░░░░░░   ░░░░░    ░░░░░ ░░░░░░░░░░   ░░░░░   ░░░░░ ░░░░░    ░░░░░   ░░░░░░░░░  ░░░░░░░░░░  ▐█',
	'█▌                                                                                                                           ▐█',
	'███████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████'
}

dashboard.section.header.opts.hl = ""

-- Git status line
local function git_info()
  local branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("\n", "")
  if branch == "" then return "" end
  local dirty = vim.fn.system("git status --porcelain 2>/dev/null")
  local marker = dirty ~= "" and " ●" or " ✓"
  return "  " .. branch .. marker
end

-- Last modified files in the current git project
local function recent_project_files()
  local files = vim.fn.systemlist(
    "git ls-files --others --exclude-standard --cached 2>/dev/null | xargs ls -t 2>/dev/null | head -5"
  )
  if #files == 0 then return { "  (no project files found)" } end
  local result = {}
  for _, f in ipairs(files) do
    table.insert(result, "  " .. f)
  end
  return result
end

-- Git section (shown above shortcuts)
local git_line = git_info()
local git_section = {
  type = "group",
  val = git_line ~= "" and {
    { type = "text", val = git_line, opts = { position = "center", hl = "Comment" } },
    { type = "padding", val = 1 },
  } or {},
  opts = { spacing = 0 },
}

-- Helpers for the command grid
local function pad_right(text, width)
  local len = vim.fn.strdisplaywidth(text)
  if len >= width then return text end
  return text .. string.rep(" ", width - len)
end

local COL_W = 30

local function grid_line(left, right)
  local l = pad_right(left, COL_W)
  local r = pad_right(right, COL_W)
  return " " .. l .. " | " .. r
end

local function grid_border(char_l, char_r, char_mid)
  return " " .. char_l .. string.rep("─", COL_W + 1) .. char_mid .. string.rep("─", COL_W + 1) .. char_r
end

local command_grid = {
  type = "group",
  val = {
    { type = "text", val = grid_border("┌", "┐", "┬"), opts = { position = "center", hl = "Comment" } },
    { type = "text", val = grid_line("[s] Select Workspace", "[b] Browse Files"),   opts = { position = "center", hl = "Comment" } },
    { type = "text", val = grid_line("[r] Recent Files",     "[g] Live Grep"),       opts = { position = "center", hl = "Comment" } },
    { type = "text", val = grid_line("[c] Neovim Config",    "[t] Floaterm"),         opts = { position = "center", hl = "Comment" } },
    { type = "text", val = grid_line("[q] Quit", ""),                                opts = { position = "center", hl = "Comment" } },
    { type = "text", val = grid_border("└", "┘", "┴"), opts = { position = "center", hl = "Comment" } },
  },
  opts = { spacing = 0 },
}

-- Footer: recent project files
local footer_lines = {}
for _, line in ipairs(recent_project_files()) do
  table.insert(footer_lines, line)
end
dashboard.section.footer.val = footer_lines
dashboard.section.footer.opts.hl = "Comment"

-- Workspaces from vim-ctrlspace
local function get_workspaces()
  local ws_dir = vim.g.CtrlSpaceWorkspacesDir
    or (vim.fn.fnamemodify(vim.fn.getcwd(), ":p"):gsub("/$", ""))
  local ws_file = ws_dir .. "/.cs_workspaces"
  local names = {}
  local f = io.open(ws_file, "r")
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

-- Workspace grid: 2 columns, keys 1–9 then a–z as needed
local ws_keys = {}
for i = 1, 9 do ws_keys[i] = tostring(i) end
local extra = {"a","b","c","d","e","f","h","i","j","k","l","m",
               "n","o","p","u","v","w","x","y","z"}
for _, k in ipairs(extra) do table.insert(ws_keys, k) end

local ws_grid_lines = {
  { type = "text", val = grid_border("┌", "┐", "┬"),
    opts = { position = "center", hl = "Comment" } },
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

-- Keymaps (mirrors the grid)
local function map_keys(bufnr)
  local opts = { buffer = bufnr, noremap = true, silent = true, nowait = true }
  vim.keymap.set("n", "s", "<cmd>CtrlSpace<CR>",                                                                              opts)
  vim.keymap.set("n", "b", "<cmd>FzfLua files<CR>",                                                                          opts)
  vim.keymap.set("n", "r", "<cmd>FzfLua oldfiles<CR>",                                                                       opts)
  vim.keymap.set("n", "g", "<cmd>FzfLua live_grep<CR>",                                                                      opts)
  vim.keymap.set("n", "c", "<cmd>e $MYVIMRC | cd %:p:h | split . | wincmd k | pwd<CR>",                                      opts)
  vim.keymap.set("n", "t", "<cmd>FloatermNew --height=0.4 --position=bottom --wintype=split<CR>",                             opts)
  vim.keymap.set("n", "q", "<cmd>qa<CR>",                                                                                    opts)
  -- Workspace shortcuts
  for i, name in ipairs(workspaces) do
    local key = ws_keys[i]
    if key then
      vim.keymap.set("n", key, function()
        vim.cmd("CtrlSpaceLoadWorkspace " .. vim.fn.fnameescape(name))
      end, opts)
    end
  end
end

-- Layout
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

-- Send config to alpha
alpha.setup(dashboard.config)

vim.api.nvim_create_autocmd("FileType", {
    command = [[setlocal buflisted fillchars=eob:\ ]],
    desc = "Fix buffer movement, remove eob in alpha.",
    group = group,
    pattern = "alpha",
})

vim.cmd([[
    autocmd FileType alpha setlocal nofoldenable
    autocmd User AlphaReady set laststatus=0 | autocmd BufUnload <buffer> set laststatus=3
]])

local alpha_start_group = vim.api.nvim_create_augroup("AlphaStart", { clear = true })
vim.api.nvim_create_autocmd("TabNewEntered", {
    callback = function()
        alpha.start()
    end,
    group = alpha_start_group,
})

vim.api.nvim_create_autocmd({ "FileType", "User" }, {
  pattern = { "alpha", "AlphaReady" },
  callback = function(ev)
    local buf = ev.buf or vim.api.nvim_get_current_buf()
    if vim.bo[buf].filetype == "alpha" then
      map_keys(buf)
    end
  end,
})

end
}
