local function create_state(buffer_lines)
	local commands = {}
	local autocmds = {}
	local number_titles_calls = 0

	return {
		commands = commands,
		autocmds = autocmds,
		get_buffer_lines = function()
			return buffer_lines
		end,
		set_buffer_lines = function(lines)
			buffer_lines = {}
			for _, line in ipairs(lines) do
				table.insert(buffer_lines, line)
			end
		end,
		core = {
			number_titles = function(_)
				number_titles_calls = number_titles_calls + 1
			end,
			remove_title_numbers = function(_) end,
		},
		get_number_titles_calls = function()
			return number_titles_calls
		end,
	}
end

local function assert_true(condition, message)
	if not condition then
		error(message)
	end
end

local function reset_modules()
	package.loaded["markdown-title-numbering.core"] = nil
	package.loaded["lua.markdown-title-numbering.init"] = nil
end

local function run_case(fn)
	local ok, err = pcall(fn)
	if ok then
		print("PASS")
		return true
	end

	print("FAIL: " .. err)
	return false
end

local function with_patched_vim(state, fn)
	local nvim = _G.vim
	local original_create_user_command = nvim.api.nvim_create_user_command
	local original_create_autocmd = nvim.api.nvim_create_autocmd
	local original_get_lines = nvim.api.nvim_buf_get_lines
	local original_set_lines = nvim.api.nvim_buf_set_lines

	nvim.api.nvim_create_user_command = function(name, callback, _)
		state.commands[name] = callback
	end

	nvim.api.nvim_create_autocmd = function(_, opts)
		table.insert(state.autocmds, opts)
	end

	nvim.api.nvim_buf_get_lines = function(_, start_idx, end_idx, _)
		local lines = state.get_buffer_lines()
		if start_idx == 0 and end_idx == 1 then
			if #lines == 0 then
				return {}
			end
			return { lines[1] }
		end

		if start_idx == 0 and end_idx == -1 then
			local copied = {}
			for _, line in ipairs(lines) do
				table.insert(copied, line)
			end
			return copied
		end

		return {}
	end

	nvim.api.nvim_buf_set_lines = function(_, start_idx, end_idx, _, lines)
		if start_idx == 0 and end_idx == -1 then
			state.set_buffer_lines(lines)
		end
	end

	local ok, err = pcall(fn)

	nvim.api.nvim_create_user_command = original_create_user_command
	nvim.api.nvim_create_autocmd = original_create_autocmd
	nvim.api.nvim_buf_get_lines = original_get_lines
	nvim.api.nvim_buf_set_lines = original_set_lines

	if not ok then
		error(err)
	end
end

local M = {}

function M.run_tests()
	local passed = 0
	local failed = 0

	print("Running marker mode tests...")

	print("\nTest 1: setup registers commands without toggle")
	if run_case(function()
		local state = create_state({ "# Main Title" })
		with_patched_vim(state, function()
			reset_modules()
			package.loaded["markdown-title-numbering.core"] = state.core
			local plugin = require("lua.markdown-title-numbering.init")
			plugin.setup({})

			assert_true(type(state.commands.MarkdownTitleNumber) == "function", "missing MarkdownTitleNumber command")
			assert_true(type(state.commands.MarkdownTitleNumberRemove) == "function", "missing MarkdownTitleNumberRemove command")
			assert_true(state.commands.MarkdownTitleNumberToggle == nil, "MarkdownTitleNumberToggle should not exist")
		end)
	end) then
		passed = passed + 1
	else
		failed = failed + 1
	end

	print("\nTest 2: MarkdownTitleNumber inserts marker and numbers")
	if run_case(function()
		local state = create_state({ "# Main Title", "## Intro" })
		with_patched_vim(state, function()
			reset_modules()
			package.loaded["markdown-title-numbering.core"] = state.core
			local plugin = require("lua.markdown-title-numbering.init")
			plugin.setup({})

			state.commands.MarkdownTitleNumber()

			local lines = state.get_buffer_lines()
			assert_true(lines[1] == "<!-- MarkdownTitleNumber -->", "marker was not inserted at first line")
			assert_true(state.get_number_titles_calls() == 1, "number_titles should be called once")
		end)
	end) then
		passed = passed + 1
	else
		failed = failed + 1
	end

	print("\nTest 3: BufWritePre only numbers when marker exists")
	if run_case(function()
		local state = create_state({ "# Main Title", "## Intro" })
		with_patched_vim(state, function()
			reset_modules()
			package.loaded["markdown-title-numbering.core"] = state.core
			local plugin = require("lua.markdown-title-numbering.init")
			plugin.setup({})

			assert_true(type(state.autocmds[1]) == "table", "BufWritePre autocmd was not created")

			state.autocmds[1].callback()
			assert_true(state.get_number_titles_calls() == 0, "should not number without marker")

			state.commands.MarkdownTitleNumber()
			state.autocmds[1].callback()
			assert_true(state.get_number_titles_calls() == 2, "should number with marker on save")
		end)
	end) then
		passed = passed + 1
	else
		failed = failed + 1
	end

	print("\nTest results: " .. passed .. " passed, " .. failed .. " failed")
	return passed, failed
end

return M
