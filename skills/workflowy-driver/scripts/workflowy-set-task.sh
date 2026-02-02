#!/bin/bash
# Write the current workflowy task ID to the project file
# Usage: workflowy-set-task.sh <task-id> [root-id]

task_id="$1"
root_id="$2"

if [ -z "$task_id" ]; then
    echo "Usage: workflowy-set-task.sh <task-id> [root-id]" >&2
    exit 1
fi

project_dir="$HOME/.claude/projects/$(pwd | tr '/' '-')"
mkdir -p "$project_dir"

echo "$task_id" > "$project_dir/workflowy-current-task"

if [ -n "$root_id" ]; then
    echo "$root_id" > "$project_dir/workflowy-current-root"
fi
