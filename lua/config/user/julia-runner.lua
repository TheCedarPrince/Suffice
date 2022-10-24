-- A function to parse the pass fail total columns of the results
-- If all the tests pass or all fail there will be only two 
-- columns. In these events we plead ignorance and just 
-- track the total tests. We will handle these cases later
local function calc_pass_fail_total(line)
    pft = {}
    for v in string.gmatch(current_line, "(%s%d+%s)") do
        table.insert(pft, v)
    end
    if #pft == 3 then
        return {
            pass = pft[1],
            fail = pft[2],
            total = pft[3],
            missing = false,
            failed_lines = {},
        }
    else
        return {
            pass = "0",
            fail = "0",
            total = pft[#pft],
            missing = "true",
            failed_lines = {},
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
local function check_results(res)
	for t in pairs(res) do
		pf = res[t].pass + res[t].fail
		go = tonumber(pf) == tonumber(res[t].total)
		if go then
			res[t].missing = "false"
		else
      res[t].pass = res[t].total 
      res[t].missing = "false"
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
  elseif
    tonumber(test_res.fail) + tonumber(test_res.pass) == tonumber(test_res.total) then
    test_res.missing = "false"
  end
  return test_res
end

-- parse the stdout of the julia test results.. sure wish there was a json option
local function parse_test_results(results)
	res = {}
  -- this is what res should look like
	-- res["name"] = {pass = 1, fail = 1, total = 2, missing = false, failed_lines = { "12" }}
	need_pass_calc = {}
	if results then
    -- do it in zulu order because its easier
		for i = 1, #results do
			current_line = results[#results + 1 - i]
      -- every row of the results table has a |
			if string.find(current_line, "|") then
        -- don't do anything with this line
				if string.find(current_line, "Test Summary:") then
					skip = true
				else
					test_name = ltrim(rtrim(vim.split(current_line, " | ")[1]))
					res[test_name] = calc_pass_fail_total(current_line)
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
	check_results(res)

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
  group = vim.api.nvim_create_augroup("julia-autotest", {clear = true}),
  pattern = "runtests.jl",
  callback = function(_, data)
    vim.cmd(":AutoTest")
  end
})

local function create_fail_pass_vtext(test)
  vim.api.nvim_set_hl(0, 'success', { fg = "green" })
  vim.api.nvim_set_hl(0, 'fail', { fg = "red" })
  pass_chunk = {"Pass: "..test.pass .. " ", "success"}
  -- pass_chunk = { string.rep("■", test.pass), "success" }
  err_chunk = {"Fail: "..test.fail .. " ", "fail"}
  -- err_chunk = { string.rep("■", test.fail), "fail" }
  return {pass_chunk, err_chunk}
end

local function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

-- looks for the Project.toml to use for the test
local function julia_project_dir()
  bufnr = vim.fn.bufnr('%')
  -- ns_id = vim.api.nvim_create_namespace('julia-testing')
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
          for ix, f in ipairs(test.failed_lines) do
            id = id + 1
            fline = tonumber(test.failed_lines[ix]) - 1
            opts = {
              end_line = 10,
              id = id,
              virt_text = {{"﮻ Test Failed", "error"}},
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
