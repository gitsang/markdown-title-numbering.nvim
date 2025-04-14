# Markdown Title Numbering

A Neovim plugin for automatically numbering markdown titles.

## Installation

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
    'gitsang/markdown-title-numbering.nvim',
    config = function()
        require('markdown-title-numbering').setup({
            -- your configuration here (optional)
        })
    end
}
```

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    'gitsang/markdown-title-numbering.nvim',
    config = function()
        require('markdown-title-numbering').setup({
            -- your configuration here (optional)
        })
    end
}

```

### Default Configuration

```lua
require('markdown-title-numbering').setup({
    -- Default numbering format
    format = {
        [2] = "%d.",      -- ## 1. Title
        [3] = "%d.%d",    -- ### 1.1 Title
        [4] = "%d.%d.%d", -- #### 1.1.1 Title
        [5] = "%d.%d.%d.%d", -- ##### 1.1.1.1 Title
        [6] = "%d.%d.%d.%d.%d", -- ###### 1.1.1.1.1 Title
    },
    -- Whether to automatically number titles when saving markdown files
    auto_number_on_save = true,
    -- File patterns to apply the numbering
    file_patterns = { "*.md", "*.markdown" },
    -- Whether to add a space after the number
    space_after_number = true,
    -- Skip level 1 headers (# Title)
    skip_level_1 = true,
})

```
