local M = {}
local vim = rawget(_G, "vim")
local MARKER_LINE = "<!-- MarkdownTitleNumber auto -->"

-- Default configuration
local default_config = {
	-- Default numbering format
	format = {
		[2] = "%d. ", -- ## 1. Title
		[3] = "%d.%d ", -- ### 1.1 Title
		[4] = "%d.%d.%d ", -- #### 1.1.1 Title
		[5] = "%d.%d.%d.%d ", -- ##### 1.1.1.1 Title
		[6] = "%d.%d.%d.%d.%d ", -- ###### 1.1.1.1.1 Title
	},
	-- File patterns to apply the numbering (empty means all markdown files)
	file_patterns = { "*.md", "*.mdx", "*.markdown" },
}

-- User configuration
M.config = {}

local function has_marker_line(lines)
	for _, line in ipairs(lines) do
		if line == MARKER_LINE then
			return true
		end
	end

	return false
end

local function get_front_matter_end(lines)
	if lines[1] ~= "---" then
		return nil
	end

	for i = 2, #lines do
		if lines[i] == "---" then
			return i
		end
	end

	return nil
end

local function get_marker_insert_position(lines)
	local front_matter_end = get_front_matter_end(lines)
	if not front_matter_end then
		return 1, false
	end

	if lines[front_matter_end + 1] == "" then
		return front_matter_end + 2, false
	end

	return front_matter_end + 1, true
end

local function ensure_marker_line(lines)
	if has_marker_line(lines) then
		return lines, false
	end

	local insert_position, needs_blank_before_marker = get_marker_insert_position(lines)
	local updated_lines = {}

	for i = 1, insert_position - 1 do
		table.insert(updated_lines, lines[i])
	end

	if needs_blank_before_marker then
		table.insert(updated_lines, "")
	end

	table.insert(updated_lines, MARKER_LINE)
	table.insert(updated_lines, "")

	for i = insert_position, #lines do
		local line = lines[i]
		table.insert(updated_lines, line)
	end

	return updated_lines, true
end

-- Initialize the plugin with user config
function M.setup(user_config)
	M.config = vim.tbl_deep_extend("force", default_config, user_config or {})

	-- Set up autocommands
	vim.api.nvim_create_autocmd("BufWritePre", {
		pattern = M.config.file_patterns,
		callback = function()
			local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
			if has_marker_line(lines) then
				M.number_titles()
			end
		end,
	})

	-- Create user commands
	vim.api.nvim_create_user_command("MarkdownTitleNumber", function()
		local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
		local updated_lines, has_inserted = ensure_marker_line(lines)
		if has_inserted then
			vim.api.nvim_buf_set_lines(0, 0, -1, false, updated_lines)
		end

		M.number_titles()
	end, { desc = "Number markdown titles" })

	vim.api.nvim_create_user_command("MarkdownTitleNumberRemove", function()
		M.remove_title_numbers()
	end, { desc = "Remove markdown title numbers" })
end

-- Load the core functionality
M.core = require("markdown-title-numbering.core")

-- Number titles in the current buffer
function M.number_titles()
	M.core.number_titles(M.config)
end

-- Remove title numbers in the current buffer
function M.remove_title_numbers()
	M.core.remove_title_numbers(M.config)
end

M._has_marker_line = has_marker_line
M._ensure_marker_line = ensure_marker_line

return M
