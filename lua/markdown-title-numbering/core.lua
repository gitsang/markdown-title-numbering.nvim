local M = {}

-- Check if a line is a fenced code block delimiter
-- Returns: is_delimiter, is_opening
local function is_code_block_delimiter(line)
	local delimiter = line:match("^```+") or line:match("^~~~+")
	if delimiter then
		return true, true
	end
	return false, false
end

-- Parse a markdown title line
-- Returns: level, has_number, title_text
local function parse_title(line)
	-- Match markdown headers (e.g., "## 1. Title" or "## Title")
	local level, rest = line:match("^(#+)%s+(.*)")
	if not level then
		return nil, false, nil
	end

	-- Get header level (number of # symbols)
	level = #level

	-- Check if the title already has a number and extract the title text
	-- First try to match patterns like "1. Title", "1.1. Title", "1.1.1. Title", etc.
	local number_part, title_text = rest:match("^([%d%.]+%.%s+)(.*)")
	local has_number = number_part ~= nil

	-- If that didn't match, try patterns like "1 Title", "1.1 Title", "1.1.1 Title", etc.
	if not has_number then
		number_part, title_text = rest:match("^([%d%.]+)%s+(.*)")
		has_number = number_part ~= nil
	end

	-- If no number pattern was found, use the entire rest as the title text
	if not has_number then
		title_text = rest
	end

	return level, has_number, title_text
end

-- Format a number according to the specified format
local function format_number(counters, level, format_spec)
	local format_str = format_spec[level]
	if not format_str then
		return ""
	end

	-- Create an array of counter values to use with string.format
	local values = {}
	for i = 2, level do
		table.insert(values, counters[i] or 0)
	end

	return string.format(format_str, unpack(values))
end

-- Number titles in the current buffer
function M.number_titles(config)
	-- First, remove all title numbers
	M.remove_title_numbers(config)
	
	-- Get the lines after removing numbers
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local counters = {0, 0, 0, 0, 0, 0}  -- Initialize counters for all levels to 0
	local modified_lines = {}
	local in_code_block = false

	for i, line in ipairs(lines) do
		-- Check if this line is a code block delimiter
		local is_delimiter, _ = is_code_block_delimiter(line)
		if is_delimiter then
			in_code_block = not in_code_block
			modified_lines[i] = line
		elseif in_code_block then
			-- Skip processing if we're inside a code block
			modified_lines[i] = line
		else
			local level, _, title_text = parse_title(line)

			if level and level > 1 and (not config.skip_level_1 or level > 1) then
				-- Reset counters for levels deeper than the current one
				for j = level + 1, 6 do
					counters[j] = 0
				end

				-- Increment the counter for the current level
				counters[level] = counters[level] + 1

				-- Format the number according to the configuration
				local number_str = format_number(counters, level, config.format)

				-- Add the formatted number to the title
				local prefix = string.rep("#", level)
				local space = config.space_after_number and " " or ""
				modified_lines[i] = string.format("%s %s%s%s", prefix, number_str, space, title_text)
			else
				modified_lines[i] = line
			end
		end
	end

	-- Update the buffer with the modified lines
	vim.api.nvim_buf_set_lines(0, 0, -1, false, modified_lines)
end

-- Remove title numbers in the current buffer
function M.remove_title_numbers(config)
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local modified_lines = {}
	local in_code_block = false

	for i, line in ipairs(lines) do
		-- Check if this line is a code block delimiter
		local is_delimiter, _ = is_code_block_delimiter(line)
		if is_delimiter then
			in_code_block = not in_code_block
			modified_lines[i] = line
		elseif in_code_block then
			-- Skip processing if we're inside a code block
			modified_lines[i] = line
		else
			local level, has_number, title_text = parse_title(line)

			if level and has_number then
				-- Remove the number from the title
				local prefix = string.rep("#", level)
				modified_lines[i] = string.format("%s %s", prefix, title_text)
			else
				modified_lines[i] = line
			end
		end
	end

	-- Update the buffer with the modified lines
	vim.api.nvim_buf_set_lines(0, 0, -1, false, modified_lines)
end

-- Export functions for testing
M._parse_title = parse_title
M._format_number = format_number

return M
