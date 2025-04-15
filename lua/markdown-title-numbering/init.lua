local M = {}

-- Default configuration
local default_config = {
	-- Default numbering format
	format = {
		[2] = "%d.", -- ## 1. Title
		[3] = "%d.%d", -- ### 1.1 Title
		[4] = "%d.%d.%d", -- #### 1.1.1 Title
		[5] = "%d.%d.%d.%d", -- ##### 1.1.1.1 Title
		[6] = "%d.%d.%d.%d.%d", -- ###### 1.1.1.1.1 Title
	},
	-- Whether to automatically number titles when saving markdown files
	auto_number_on_save = true,
	-- File patterns to apply the numbering (empty means all markdown files)
	file_patterns = { "*.md", "*.markdown" },
	-- Whether to add a space after the number
	space_after_number = true,
	-- Skip level 1 headers (# Title)
	skip_level_1 = true,
}

-- User configuration
M.config = {}

-- Initialize the plugin with user config
function M.setup(user_config)
	M.config = vim.tbl_deep_extend("force", default_config, user_config or {})

	-- Set up autocommands
	if M.config.auto_number_on_save then
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = M.config.file_patterns,
			callback = function()
				M.number_titles()
			end,
		})
	end

	-- Create user commands
	vim.api.nvim_create_user_command("MarkdownNumberTitles", function()
		M.number_titles()
	end, { desc = "Number markdown titles" })

	vim.api.nvim_create_user_command("MarkdownRemoveTitleNumbers", function()
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

return M
