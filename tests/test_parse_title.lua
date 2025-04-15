-- Test file for parse_title function

-- Load the module
local core = require("lua.markdown-title-numbering.core")

-- Get access to the private parse_title function
local parse_title = core._parse_title

-- If parse_title is nil, print an error message
if not parse_title then
    print("Error: parse_title function is nil. Make sure it's exported as core._parse_title")
    return {
        run_tests = function() return 0, 1 end
    }
end

-- Test cases
local test_cases = {
    {
        name = "Level 1 title without number",
        input = "# Title",
        expected = {level = 1, has_number = false, title_text = "Title"}
    },
    {
        name = "Level 2 title without number",
        input = "## Title",
        expected = {level = 2, has_number = false, title_text = "Title"}
    },
    {
        name = "Level 2 title with number",
        input = "## 1. Title",
        expected = {level = 2, has_number = true, title_text = "Title"}
    },
    {
        name = "Level 3 title with number",
        input = "### 1.1. Title",
        expected = {level = 3, has_number = true, title_text = "Title"}
    },
    {
        name = "Level 4 title with number",
        input = "#### 1.1.1. Title",
        expected = {level = 4, has_number = true, title_text = "Title"}
    },
    {
        name = "Level 5 title with number",
        input = "##### 1.1.1.1. Title",
        expected = {level = 5, has_number = true, title_text = "Title"}
    },
    {
        name = "Level 6 title with number",
        input = "###### 1.1.1.1.1. Title",
        expected = {level = 6, has_number = true, title_text = "Title"}
    },
    {
        name = "Not a title",
        input = "This is not a title",
        expected = {level = nil, has_number = false, title_text = nil}
    }
}

-- Run tests
local function run_tests()
    print("Running parse_title tests...")
    local passed = 0
    local failed = 0
    
    for i, test in ipairs(test_cases) do
        print("\nTest " .. i .. ": " .. test.name)
        print("Input: " .. test.input)
        
        local level, has_number, title_text = parse_title(test.input)
        
        print("Expected: level=" .. tostring(test.expected.level) .. 
              ", has_number=" .. tostring(test.expected.has_number) .. 
              ", title_text=" .. tostring(test.expected.title_text))
        print("Got: level=" .. tostring(level) .. 
              ", has_number=" .. tostring(has_number) .. 
              ", title_text=" .. tostring(title_text))
        
        local success = level == test.expected.level and 
                       has_number == test.expected.has_number and 
                       title_text == test.expected.title_text
        
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

return {
    run_tests = run_tests
}
