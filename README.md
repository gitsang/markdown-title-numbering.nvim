# Markdown Title Numbering

A Neovim plugin for automatically numbering markdown titles.

## 1. Overview

This plugin automatically numbers markdown titles according to their hierarchy level, making it easy to maintain structured documents.

For detailed documentation, please see `:help markdown-title-numbering` after installation.

## 2. Quick Start

### 2.1 Installation

#### 2.1.1 Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

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

#### 2.1.2 Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'gitsang/markdown-title-numbering.nvim',
  opts = {
    -- your configuration here (optional)
  }
}
```

### 2.2 Commands

- `:MarkdownTitleNumber` - Number all markdown titles in the current buffer
- `:MarkdownTitleNumberRemove` - Remove numbers from all markdown titles in the current buffer
- `:MarkdownTitleNumberToggle` - Toggle automatic markdown title numbering on save

### 2.3 Keybindings

```lua
{
  'gitsang/markdown-title-numbering.nvim',
  keys = {
    { '<leader>mtn', ':MarkdownTitleNumber<CR>', desc = 'Number markdown titles' },
    { '<leader>mtnr', ':MarkdownTitleNumberRemove<CR>', desc = 'Remove markdown title numbers' },
    { '<leader>mtnt', ':MarkdownTitleNumberToggle<CR>', desc = 'Toggle markdown title numbering' },
  }
}
```

### 2.4 Configuration

```lua
{
  'gitsang/markdown-title-numbering.nvim',
  opts = {
    auto_number_on_save = true, -- Auto number on save
    file_patterns = { "*.md", "*.mdx", "*.markdown" }, -- File patterns to apply
    format = {
      [2] = "%d.", -- ## 1. Title
      [3] = "%d.%d", -- ### 1.1 Title
      [4] = "%d.%d.%d", -- #### 1.1.1 Title
      [5] = "%d.%d.%d.%d", -- ##### 1.1.1.1 Title
      [6] = "%d.%d.%d.%d.%d", -- ###### 1.1.1.1.1 Title
    },
  }
}
```

### 2.5 Example

Before:

```markdown
# Main Title

## Introduction

### Background
```

After:

```markdown
# Main Title

## 1. Introduction

### 1.1 Background
```

For complete documentation including configuration options and features, see `:help markdown-title-numbering`.
