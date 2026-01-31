#!/bin/bash
# Hook that fires after a tool completes (PostToolUse)
# Marks the "awaiting permission" Workflowy node as complete

# Read hook input from stdin
input=$(cat)

cwd=$(echo "$input" | jq -r '.cwd // ""')

if [ -z "$cwd" ]; then
    exit 0
fi

project_dir="$HOME/.claude/projects/$(echo "$cwd" | tr '/' '-')"
request_file="$project_dir/workflowy-current-tool-request"

if [ -f "$request_file" ]; then
    node_id=$(cat "$request_file")
    rm -f "$request_file"

    if [ -n "$node_id" ]; then
        workflowy complete --id "$node_id" 2>/dev/null
    fi
fi

exit 0
