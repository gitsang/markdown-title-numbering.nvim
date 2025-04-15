-- Test runner for markdown-title-numbering.nvim

-- Add the project directory to the Lua path
package.path = package.path .. ";../?.lua"

-- Load test modules
local test_parse_title = require("tests.test_parse_title")
local test_remove_numbers = require("tests.test_remove_numbers")

-- Run tests
print("Running all tests...")
print("\n=== parse_title tests ===")
local parse_title_passed, parse_title_failed = test_parse_title.run_tests()

print("\n=== remove_title_numbers tests ===")
local remove_numbers_passed, remove_numbers_failed = test_remove_numbers.run_tests()

-- Print summary
print("\n=== Test Summary ===")
print("parse_title: " .. parse_title_passed .. " passed, " .. parse_title_failed .. " failed")
print("remove_title_numbers: " .. remove_numbers_passed .. " passed, " .. remove_numbers_failed .. " failed")
print("Total: " .. (parse_title_passed + remove_numbers_passed) .. " passed, " .. (parse_title_failed + remove_numbers_failed) .. " failed")

-- Exit with appropriate status code
if parse_title_failed > 0 or remove_numbers_failed > 0 then
    os.exit(1)
else
    os.exit(0)
end
