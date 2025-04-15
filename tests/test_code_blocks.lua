-- Test script for code block handling

-- Define a simple version of the is_code_block_delimiter function for testing
local function is_code_block_delimiter(line)
    local delimiter = line:match("^```+") or line:match("^~~~+")
    if delimiter then
        return true, true
    end
    return false, false
end

-- Define a simple version of the parse_title function for testing
local function parse_title(line)
    -- Match markdown headers (e.g., "## 1. Title" or "## Title")
    local level, rest = line:match("^(#+)%s+(.*)")
    if not level then
        return nil, false, nil
    end

    -- Get header level (number of # symbols)
    level = #level

    -- Check if the title already has a number and extract the title text
    -- First try to match patterns like "1. Title", "1.1. Title", "1.1.1. Title", etc.
    local number_part, title_text = rest:match("^([%d%.]+%.%s+)(.*)")
    local has_number = number_part ~= nil

    -- If that didn't match, try patterns like "1 Title", "1.1 Title", "1.1.1 Title", etc.
    if not has_number then
        number_part, title_text = rest:match("^([%d%.]+)%s+(.*)")
        has_number = number_part ~= nil
    end

    -- If no number pattern was found, use the entire rest as the title text
    if not has_number then
        title_text = rest
    end

    return level, has_number, title_text
end

-- Define a simple version of the number_titles function for testing
local function number_titles(lines)
    local counters = {0, 0, 0, 0, 0, 0}  -- Initialize counters for all levels to 0
    local modified_lines = {}
    local in_code_block = false

    for i, line in ipairs(lines) do
        -- Check if this line is a code block delimiter
        local is_delimiter, _ = is_code_block_delimiter(line)
        if is_delimiter then
            in_code_block = not in_code_block
            modified_lines[i] = line
        elseif in_code_block then
            -- Skip processing if we're inside a code block
            modified_lines[i] = line
        else
            local level, _, title_text = parse_title(line)

            if level and level > 1 then
                -- Reset counters for levels deeper than the current one
                for j = level + 1, 6 do
                    counters[j] = 0
                end

                -- Increment the counter for the current level
                counters[level] = counters[level] + 1

                -- Format the number (simplified for testing)
                local number_str = ""
                if level == 2 then
                    number_str = counters[2] .. "."
                elseif level == 3 then
                    number_str = counters[2] .. "." .. counters[3]
                elseif level == 4 then
                    number_str = counters[2] .. "." .. counters[3] .. "." .. counters[4]
                end

                -- Add the formatted number to the title
                local prefix = string.rep("#", level)
                modified_lines[i] = string.format("%s %s %s", prefix, number_str, title_text)
            else
                modified_lines[i] = line
            end
        end
    end

    return modified_lines
end

local M = {}

-- Function to run tests
function M.run_tests()
    -- Test cases
    local test_cases = {
        {
            name = "Skip titles in code blocks",
            input = {
                "# Main Title",
                "## Introduction",
                "```",
                "## This is not a title",
                "### This is also not a title",
                "```",
                "## Methods",
                "### Data Collection"
            },
            expected = {
                "# Main Title",
                "## 1. Introduction",
                "```",
                "## This is not a title",
                "### This is also not a title",
                "```",
                "## 2. Methods",
                "### 2.1 Data Collection"
            }
        },
        {
            name = "Multiple code blocks",
            input = {
                "# Main Title",
                "## Introduction",
                "```",
                "## Code block 1",
                "```",
                "## Methods",
                "~~~",
                "## Code block 2",
                "~~~",
                "## Results"
            },
            expected = {
                "# Main Title",
                "## 1. Introduction",
                "```",
                "## Code block 1",
                "```",
                "## 2. Methods",
                "~~~",
                "## Code block 2",
                "~~~",
                "## 3. Results"
            }
        },
        {
            name = "Nested headings in code blocks",
            input = {
                "# Main Title",
                "## Introduction",
                "```markdown",
                "# Heading 1",
                "## Heading 2",
                "### Heading 3",
                "```",
                "## Methods"
            },
            expected = {
                "# Main Title",
                "## 1. Introduction",
                "```markdown",
                "# Heading 1",
                "## Heading 2",
                "### Heading 3",
                "```",
                "## 2. Methods"
            }
        }
    }

    -- Run tests
    print("Running code block handling tests...")
    local passed = 0
    local failed = 0

    for i, test in ipairs(test_cases) do
        print("\nTest " .. i .. ": " .. test.name)
        print("Input:")
        for _, line in ipairs(test.input) do
            print("  " .. line)
        end
        
        local result = number_titles(test.input)
        
        print("Expected:")
        for _, line in ipairs(test.expected) do
            print("  " .. line)
        end
        
        print("Got:")
        for _, line in ipairs(result) do
            print("  " .. line)
        end
        
        local success = true
        if #result ~= #test.expected then
            success = false
        else
            for j = 1, #result do
                if result[j] ~= test.expected[j] then
                    success = false
                    break
                end
            end
        end
        
        if success then
            print("PASS")
            passed = passed + 1
        else
            print("FAIL")
            failed = failed + 1
        end
    end

    print("\nTest results: " .. passed .. " passed, " .. failed .. " failed")
    return passed, failed
end

return M
