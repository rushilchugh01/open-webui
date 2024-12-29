#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Print message with color
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Check if we're in a git repository (works from any subdirectory)
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    print_message $RED "Error: Not a git repository. Please run this script from within a git repository."
    exit 1
fi

# Change to the repository root directory
cd "$(git rev-parse --show-toplevel)"

# Store current branch name
current_branch=$(git symbolic-ref --short HEAD)

print_message $YELLOW "Current branch: $current_branch"

# Check if upstream remote exists
if ! git remote | grep -q "upstream"; then
    print_message $YELLOW "Adding upstream remote..."
    git remote add upstream https://github.com/open-webui/open-webui.git
fi

# Fetch all changes from upstream
print_message $YELLOW "Fetching changes from upstream..."
git fetch upstream

# Save any local changes
print_message $YELLOW "Stashing local changes..."
git stash

# Update main branch with upstream changes
print_message $YELLOW "Updating main branch..."
git checkout main
git rebase upstream/main

# Update current branch if not on main
if [ "$current_branch" != "main" ]; then
    print_message $YELLOW "Switching back to $current_branch and updating it..."
    git checkout $current_branch
    git rebase main
fi

# Restore local changes
print_message $YELLOW "Restoring local changes..."
git stash pop

print_message $GREEN "✓ Repository successfully synchronized with upstream!"
print_message $YELLOW "Current status:"
git status