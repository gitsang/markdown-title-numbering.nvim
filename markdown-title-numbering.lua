-- Prevent loading the plugin multiple times
if vim.g.loaded_markdown_title_numbering then
	return
end
vim.g.loaded_markdown_title_numbering = true

-- Load the plugin with default configuration
-- Users can override this by calling require("markdown-title-numbering").setup({...})
require("markdown-title-numbering").setup()
