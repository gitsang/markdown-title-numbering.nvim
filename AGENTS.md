# AGENTS.md - Agent Guidelines for markdown-title-numbering.nvim

This file contains guidelines for agentic coding assistants working on this repository.

## Development Commands

### Running Tests

- **Run all tests**: `cd tests && ./run_tests.sh`
- **Run single test file**: Modify `tests/run_tests.lua` to only require and run the specific test module
- Tests run in headless Neovim and output to both console and `tests/report.txt`

### Linting/Formatting

- No automated linting/formatting currently configured in this project
- Follow existing code style when making changes

## Code Style Guidelines

### File Structure

- Plugin entry point: `init.lua` (redirects to `lua/markdown-title-numbering/init.lua`)
- Main module: `lua/markdown-title-numbering/init.lua`
- Core functionality: `lua/markdown-title-numbering/core.lua`
- Tests: `tests/test_*.lua`

### Imports

- Use `require()` for module imports: `local M = require("markdown-title-numbering.core")`
- Import plugin modules from root: `local core = require("lua.markdown-title-numbering.core")` (from tests directory)

### Formatting

- **Indentation**: Use tabs (not spaces)
- **Line length**: No strict limit, keep readable (~80-100 chars)
- **Comments**: Use `--` for single-line comments, keep them concise

### Naming Conventions

- **Modules**: Snake_case: `markdown-title-numbering`
- **Functions/Variables**: Snake_case: `parse_title`, `in_code_block`
- **Constants**: Snake_case, typically ALL_CAPS for true constants (rare)
- **Private functions**: Prefix with underscore: `_parse_title`, `_format_number`
- **Tables/Objects**: Snake_case: `test_cases`, `default_config`

### Module Pattern

```lua
local M = {}

function M.public_function()
end

local M._private_function = function()
end

return M
```

### Types

- Lua is dynamically typed; no type annotations
- Use descriptive names to indicate types
- Table keys use string notation for config: `config.format[2]`

### Error Handling

- Use pattern matching (`string.match`) for validation
- Check for nil returns from API calls
- Return multiple values for success/failure: `local level, has_number, title_text = parse_title(line)`
- Don't use exceptions; check conditions explicitly

### Neovim API Usage

- Use `vim.api.nvim_*` functions for buffer operations
- Use `vim.tbl_deep_extend("force", ...)`, for config merging
- Use `vim.api.nvim_create_autocmd()` for autocommands
- Use `vim.api.nvim_create_user_command()` for user commands
- Use `string.rep("#", level)` for repeating characters

### Testing Style

- Test files named: `test_*.lua`
- Each test file exports a table with `run_tests` function
- `run_tests()` returns two values: `passed_count, failed_count`
- Test cases defined as tables with `name`, `input`, and `expected` fields
- Use `print()` for test output
- Export private functions with underscore prefix for testing: `M._parse_title = parse_title`

### Configuration

- Default config defined as table with descriptive keys
- User config merged with default using `vim.tbl_deep_extend("force", default_config, user_config or {})`
- Config options use descriptive names with underscores: `auto_number_on_save`, `file_patterns`

### String Patterns

- Use Lua pattern matching (not regex)
- Patterns like `"^(#+)%s+(.*)"` for markdown headers
- Patterns like `"^([%d%.]+%.%s+)(.*)"` for numbered titles
- Use `string.format()` for string interpolation

### Tables/Arrays

- Use `ipairs()` for numeric iteration: `for i, line in ipairs(lines) do`
- Use `table.insert()` to add items
- Use `unpack()` or table.unpack for unpacking arrays
- Initialize arrays explicitly: `{0, 0, 0, 0, 0, 0}`

### Code Organization

- Group related functions together
- Use local helper functions within modules
- Keep functions focused and single-purpose
- Document complex logic with comments

### Git Commit Messages

- Use conventional commits with emojis:
  - `✨ feat: add new feature`
  - `🐛 fix: fix bug`
  - `📚 docs: update documentation`
  - `🔧 chore: maintenance task`
  - `🧪 test: add tests`
