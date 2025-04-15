local M = {}

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

	-- Check if the title already has a number
	-- Match patterns like "1.", "1.1.", "1.1.1.", etc.
	local has_number = rest:match("^[%d%.]+%.%s+") ~= nil

	-- Extract the title text (without the number if it exists)
	local title_text
	if has_number then
		-- Try to match patterns like "1. Title", "1.2. Title", "1.2.3. Title", etc.
		title_text = rest:match("^[%d%.]+%.%s+(.*)")
		if not title_text then
			-- If no match, just use the rest as is
			title_text = rest
			has_number = false
		end
	else
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

	for i, line in ipairs(lines) do
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

	-- Update the buffer with the modified lines
	vim.api.nvim_buf_set_lines(0, 0, -1, false, modified_lines)
end

-- Remove title numbers in the current buffer
function M.remove_title_numbers(config)
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local modified_lines = {}

	for i, line in ipairs(lines) do
		local level, has_number, title_text = parse_title(line)

		if level and has_number then
			-- Remove the number from the title
			local prefix = string.rep("#", level)
			modified_lines[i] = string.format("%s %s", prefix, title_text)
		else
			modified_lines[i] = line
		end
	end

	-- Update the buffer with the modified lines
	vim.api.nvim_buf_set_lines(0, 0, -1, false, modified_lines)
end

return M
