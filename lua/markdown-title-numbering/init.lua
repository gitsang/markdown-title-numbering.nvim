local M = {}
local MARKER_LINE = "<!-- MarkdownTitleNumber -->"

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
	return lines[1] == MARKER_LINE
end

local function ensure_marker_line(lines)
	if has_marker_line(lines) then
		return lines, false
	end

	local updated_lines = { MARKER_LINE }
	for _, line in ipairs(lines) do
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
			local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)
			if has_marker_line(first_line) then
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
