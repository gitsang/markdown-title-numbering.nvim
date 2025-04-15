-- Test script for remove_title_numbers function

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

-- Define a simple version of the remove_title_numbers function for testing
local function remove_title_numbers(lines)
    local modified_lines = {}

    for i, line in ipairs(lines) do
        local level, has_number, title_text = parse_title(line)

        if level and has_number then
            -- Remove the number from the title
            local prefix = string.rep("#", level)
            modified_lines[i] = string.format("%s %s", prefix, title_text)
        else
            modified_lines[i] = line
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
        name = "Remove number from level 2 title",
        input = {"## 1. Title"},
        expected = {"## Title"}
    },
    {
        name = "Remove number from level 3 title",
        input = {"### 1.1. Title"},
        expected = {"### Title"}
    },
    {
        name = "Remove number from level 4 title",
        input = {"#### 1.1.1. Title"},
        expected = {"#### Title"}
    },
    {
        name = "Remove number from level 5 title",
        input = {"##### 1.1.1.1. Title"},
        expected = {"##### Title"}
    },
    {
        name = "Remove number from level 6 title",
        input = {"###### 1.1.1.1.1. Title"},
        expected = {"###### Title"}
    },
    {
        name = "No change for title without number",
        input = {"## Title"},
        expected = {"## Title"}
    },
    {
        name = "No change for non-title",
        input = {"This is not a title"},
        expected = {"This is not a title"}
    },
    {
        name = "Multiple lines with mixed titles",
        input = {
            "# Main Title",
            "## 1. Introduction",
            "### 1.1 Background",
            "### 1.2 Motivation",
            "## 2. Methods",
            "### 2.1 Data Collection",
            "#### 2.1.1 Survey",
            "#### 2.1.2 Interviews",
            "### 2.2 Analysis",
            "## 3. Results"
        },
        expected = {
            "# Main Title",
            "## Introduction",
            "### Background",
            "### Motivation",
            "## Methods",
            "### Data Collection",
            "#### Survey",
            "#### Interviews",
            "### Analysis",
            "## Results"
        }
    }
}

-- Run tests
print("Running remove_title_numbers tests...")
local passed = 0
local failed = 0

for i, test in ipairs(test_cases) do
    print("\nTest " .. i .. ": " .. test.name)
    print("Input:")
    for _, line in ipairs(test.input) do
        print("  " .. line)
    end
    
    local result = remove_title_numbers(test.input)
    
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
