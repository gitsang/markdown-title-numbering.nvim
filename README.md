# Markdown Title Numbering

A Neovim plugin for automatically numbering markdown titles.

## Overview

This plugin automatically numbers markdown titles according to their hierarchy level, making it easy to maintain structured documents.

For detailed documentation, please see `:help markdown-title-numbering` after installation.

## Quick Start

### Installation

#### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

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

#### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    'gitsang/markdown-title-numbering.nvim',
    opts = {
        -- your configuration here (optional)
    }
}
```

### Commands

- `:MarkdownTitleNumber` - Number all markdown titles in the current buffer
- `:MarkdownTitleNumberRemove` - Remove numbers from all markdown titles in the current buffer
- `:MarkdownTitleNumberToggle` - Toggle automatic markdown title numbering on save

### Example

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
