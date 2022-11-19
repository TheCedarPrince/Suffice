-- A function to parse the pass fail total columns of the results
-- If all the tests pass or all fail there will be only two
-- columns. In these events we plead ignorance and just
-- track the total tests. We will handle these cases later
local function calc_pass_fail_total(line)
  pft = {}
  results = vim.split(current_line, "|")[2]
  for v in string.gmatch(results, "(%s%d+%s)") do
    table.insert(pft, v)
  end
  -- count the spaces to the first number 
  -- keep track of it so we can infer if its 
  -- a pass or fail number 
  s = 0
  for c in results:gmatch"." do
    if c == " " then
      s = s + 1
    else
      s = 0
      break
    end
  end
  -- todo: clean up unused things in the table
  if #pft == 3 then
    return {
      index = "unset",
      pass = pft[1],
      fail = pft[2],
      total = pft[3],
      unknown = nil,
      missing = false,
      failed_lines = {},
      parent_set = false,
      tests = {},
      first_lvl = false,
      all_fp = false,
      all = nil,
      spaces = nil,
    }
  else
    return {
      index = "unset",
      pass = "0",
      fail = "0",
      unknown = pft[1],
      total = pft[#pft],
      missing = "true",
      failed_lines = {},
      parent_set = false,
      tests = {},
      first_lvl = false,
      all_fp = true,
      all = "unset",
      spaces = s,
    }
  end
end

local function rtrim(s)
  return s:match("^(.*%S)%s*$")
end

local function ltrim(s)
  return s:match("^%s*(.*)")
end

-- todo: rename function
-- we take in the results table, which we scan over
-- to make sure all pass and fail totals add up to the recorded total
-- value. If they checkout we aren't missing any info so we set it to
-- false.
-- The other thing that could happen is pass and fail could still
-- be 0 which means they are all pass. This is because if it was
-- all fail we would have already updated the fail values
-- as we handle the stdout that explains what happened in the fail
local function check_results(res, spaces_to_Fail)
	for t in pairs(res) do
    if res[t].spaces == nil then
      pf = res[t].pass + res[t].fail
      go = tonumber(pf) == tonumber(res[t].total)
      if go then
        res[t].missing = "false"
      else
        res[t].pass = res[t].total 
        res[t].missing = "false"
      end
    else
      if res[t].spaces < spaces_to_Fail then
        if #res[t].failed_lines == 0 then
          -- you must be an all pass
          res[t].pass = res[t].unknown
        else
          res[t].fail = res[t].unknown
        end
      else
        if #res[t].failed_lines ~= 0 then
          -- you must be an all fail
          res[t].fail = res[t].unknown
        else
          res[t].pass = res[t].unknown
        end
      end
    end
	end
end

-- We are updating fail counts after parsing the lines before/after the summary table.
-- this is why we can assume res[t].pass = res[t].total
local function updated_failed_test(test_res, line)
  table.insert(test_res.failed_lines, line)
  if tonumber(test_res.fail) + tonumber(test_res.pass) ~= tonumber(test_res.total) then
    -- check if these  dont equal maybe we failed all the tests
    test_res.fail = tostring(tonumber(test_res.fail) + 1)
  elseif tonumber(test_res.fail) + tonumber(test_res.pass) == tonumber(test_res.total) then
    test_res.missing = "false"
  end
  return test_res
end

-- parse the stdout of the julia test results.. sure wish there was a json option
local function parse_test_results(results)
  res = {}
  rev_order = {}
  tests = {}
  parent_set = false
  t = 1
  F = 0
  -- this is what res should look like
  -- res["name"] = {pass = 1, fail = 1, total = 2, missing = false, failed_lines = { "12" }}
  if results then
    -- do it in zulu order because its easier
    for i = 1, #results do
      current_line = results[#results + 1 - i]
      next_line = results[#results + 0 - i]
      -- every row of the results table has a |
      if string.find(current_line, "|") then
        -- don't do anything with this line
        if string.find(current_line, "Test Summary:") then
          skip = true
          -- count spaces to the F in Fail
          -- use this as a way to tell if the first number found is in the Pass call or Fail col
          test_sumary_titles = vim.split(current_line, "|")[2]
          for c in test_sumary_titles:gmatch"." do
            if c == "F" then
              F = F + 1
            else
              F = 0
              break
            end
          end
        else
          test_name = ltrim(rtrim(vim.split(current_line, " | ")[1]))
          raw_name = rtrim(vim.split(current_line, " | ")[1])

          -- need to figure out if we are nested inside another @testset
          raw_len = table.getn(vim.split(raw_name, " "))
          name_len = table.getn(vim.split(test_name, " "))
          res[test_name] = calc_pass_fail_total(current_line)
          res[test_name]["index"] = #results + 1 - i
          rev_order[#results + 1 - i] = test_name
          -- keep track of the number of spaces of indention
          -- this is the key to figure out if we are nested

          next_name = ltrim(rtrim(vim.split(next_line, " | ")[1]))
          next_raw_name = rtrim(vim.split(next_line, " | ")[1])
          next_raw_len = table.getn(vim.split(next_raw_name, " "))
          next_name_len = table.getn(vim.split(next_name, " "))

          current_indent = raw_len - name_len
          next_indent = next_raw_len - next_name_len

          if tonumber(next_indent) < tonumber(current_indent) then
            parent_set = false
            tests[t] = test_name
            t = t + 1
          else
            parent_set = true
            t = 0
          end

          if parent_set == true then
            res[test_name]["tests"] = tests
            res[test_name]["parent_set"] = parent_set
            tests = {}
          end
          
          if current_indent == 0 then
            res[test_name]["first_lvl"] = true
          end
        end
      elseif string.find(current_line, "Test Failed") then
        -- we are done with the table and are parsing the failures
        split_line = vim.split(current_line, ":")
        -- todo: get the evaluated line and save it so we can make it vtext
        test_name = ltrim(rtrim(split_line[1]))
        fail_line = ltrim(rtrim(split_line[3]))
        res[test_name] = updated_failed_test(res[test_name], fail_line)
      end
    end
  end
  check_results(res, F)
  -- print("->",vim.inspect(res),"<-")

  return res
end


-- this is a treesitter query / function to get the line number for a given test
-- it returns the rows of this -->>  @testset "test name" begin
local function get_testset_line_number(test_name)
  bufftype = vim.bo.filetype
  language_tree = vim.treesitter.get_parser(bufnr, bufftype)
  syntax_tree = language_tree:parse()
  root = syntax_tree[1]:root()
  query = "(macro_expression (macro_argument_list (string_literal) @name (#match? @name \"" .. test_name .. "\"))  @ml )"
  pq = vim.treesitter.parse_query("julia", query)
  for id, node, metadata in pq:iter_captures(root, bufnr, 0, vim.fn.line('$')) do
    -- there should only be one match
    -- row1, col1, row2, col2 = node:range()
    return node:range()
  end
end

-- just make an autocommand to run the tests whenever you update them
vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("julia-autotest", { clear = true }),
  pattern = "runtests.jl",
  callback = function(_, data)
    vim.cmd(":AutoTest")
  end
})

local function create_fail_pass_vtext(test)
  vim.api.nvim_set_hl(0, 'success', { fg = "green" })
  vim.api.nvim_set_hl(0, 'fail', { fg = "red" })
  if test.parent_set == true then
    pass_chunk = { "Pass: " .. test.pass .. " ", "success" }
    err_chunk = { "Fail: " .. test.fail .. " ", "fail" }
  else
    pass_chunk = { string.rep("■", test.pass), "success" }
    err_chunk = { string.rep("■", test.fail), "fail" }
  end
  return { pass_chunk, err_chunk }
end

local function file_exists(name)
  local f = io.open(name, "r")
  if f ~= nil then io.close(f) return true else return false end
end

-- looks for the Project.toml to use for the test
local function julia_project_dir()
  bufnr = vim.fn.bufnr('%')
  print(vim.fs.parents(vim.api.nvim_buf_get_name(vim.fn.bufnr('%'))))
  local root_dir
  for dir in vim.fs.parents(vim.api.nvim_buf_get_name(bufnr)) do
    if file_exists(dir .. "/Project.toml") == true then
      root_dir = dir
      break
    end
  end

  if root_dir then
    print("Found julia project at", root_dir)
    return root_dir
  end
end

-- This is the main method that is callable by a user
vim.api.nvim_create_user_command("AutoTest", function()
  bufnr = vim.fn.bufnr('%')
  ns_id = vim.api.nvim_create_namespace('julia-testing')
  vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 1, vim.fn.line('$'))
  -- TODO: Allow setting this manually
  project_dir = julia_project_dir()
  runtests = vim.fn.expand('%:p')
  print("julia", "--project=" .. project_dir, runtests)
  -- this is how you get nvim to run something in the background
  vim.fn.jobstart({ "julia", "--project=" .. project_dir, runtests }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        test_results = parse_test_results(data)
        id = 1
        for test_name in pairs(test_results) do
          test = test_results[test_name]
          line_num, col_num, line_num2, col_num2 = get_testset_line_number(test_name)
          opts = {
            end_line = 10,
            id = id,
            virt_text = create_fail_pass_vtext(test),
            virt_text_pos = 'right_align',
            -- virt_text_win_col = 20,
          }

          mark_id = vim.api.nvim_buf_set_extmark(bufnr, ns_id, line_num, col_num, opts)
          fails = {}
          for ix, f in ipairs(test.failed_lines) do
            fails[f] = f
          end
          for f in pairs(fails) do
            id = id + 1
            fline = tonumber(f) - 1
            opts = {
              end_line = 10,
              id = id,
              virt_text = { { "﮻ Test Failed", "error" } },
              virt_text_pos = 'eol',
              -- virt_text_win_col = 20,
            }
            mark_id2 = vim.api.nvim_buf_set_extmark(bufnr, ns_id, fline, col_num2, opts)
          end
          id = id + 1
        end
      end
    end,
  })
end, {})

