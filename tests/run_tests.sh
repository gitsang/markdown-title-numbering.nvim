#!/bin/bash

# Run tests and output to both console and report.txt
cd "$(dirname "$0")" # Change to the directory of this script
nvim --headless -c "luafile run_tests.lua" -c "q" 2>&1 | tee report.txt

# Check if tests passed (using the exit status of the nvim command)
if [ ${PIPESTATUS[0]} -eq 0 ]; then
    echo "Tests passed! See report.txt for details."
    exit 0
else
    echo "Tests failed! See report.txt for details."
    exit 1
fi
