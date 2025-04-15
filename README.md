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
    opts = {
        -- your configuration here (optional)
    }
}
```

### Default Configuration

These are the default configuration options:

```lua
{
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
}
```

You can override any of these options in your configuration.

## Usage

### Automatic Numbering

By default, the plugin will automatically number markdown titles when saving a markdown file. This behavior is controlled by the `auto_number_on_save` option.

### Manual Commands

The plugin provides the following commands:

- `:MarkdownNumberTitles` - Number all markdown titles in the current buffer
- `:MarkdownRemoveTitleNumbers` - Remove numbers from all markdown titles in the current buffer

### Features

- Automatically numbers markdown titles based on their hierarchy level
- Skips level 1 headers (`# Title`) by default (configurable)
- Preserves existing title numbers (won't add numbers to already numbered titles)
- Numbers start from 1 (e.g., `## 1. Title`, `### 1.1 Title`)
- Configurable numbering format for each header level
- Adds a space after the number by default (configurable)

### Example

Before:
```markdown
# Main Title
## Introduction
### Background
### Motivation
## Methods
### Data Collection
#### Survey
#### Interviews
### Analysis
## Results
```

After running `:MarkdownNumberTitles`:
```markdown
# Main Title
## 1. Introduction
### 1.1 Background
### 1.2 Motivation
## 2. Methods
### 2.1 Data Collection
#### 2.1.1 Survey
#### 2.1.2 Interviews
### 2.2 Analysis
## 3. Results
```
