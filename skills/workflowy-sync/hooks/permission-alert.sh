#!/bin/bash
# Hook that fires when Claude Code requests permission
# Posts a notification to Workflowy under the current task or root node

# Read hook input from stdin
input=$(cat)

# Extract tool name and working directory
tool_name=$(echo "$input" | jq -r '.tool_name // "Unknown"')
cwd=$(echo "$input" | jq -r '.cwd // ""')

# Derive the project directory from cwd (same convention as Claude Code)
if [ -n "$cwd" ]; then
    project_dir="$HOME/.claude/projects/$(echo "$cwd" | tr '/' '-')"
else
    exit 0
fi

# Determine where to post: task file first, fall back to root file
parent_id=""
task_file="$project_dir/workflowy-current-task"
root_file="$project_dir/workflowy-current-root"

if [ -f "$task_file" ]; then
    parent_id=$(cat "$task_file")
fi

if [ -z "$parent_id" ] && [ -f "$root_file" ]; then
    parent_id=$(cat "$root_file")
fi

# Only post to Workflowy if we have a parent node
if [ -n "$parent_id" ]; then
    create_output=$(workflowy create \
        --parent-id "$parent_id" \
        --position bottom \
        --name "<b>⏳ awaiting permission:</b> $tool_name" \
        2>/dev/null)

    # Output is "<uuid> created" — extract just the UUID
    node_id=$(echo "$create_output" | awk '{print $1}')

    # Save the node ID so PostToolUse can mark it complete
    if [ -n "$node_id" ]; then
        request_file="$project_dir/workflowy-current-tool-request"
        echo "$node_id" > "$request_file"
    fi
fi

# Exit 0 to allow the permission dialog to proceed normally
exit 0
