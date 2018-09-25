#!/bin/bash

function print_git_status()
{
    if [ -d .git ]
    then
        current_dir="$(pwd)"
        current_branch="$(git rev-parse --abbrev-ref HEAD)"
        current_commit="$(git rev-parse --verify --short HEAD)"
        current_status=""
        if [[ `git status --porcelain` ]]; then
            current_status="M"
        fi
        printf "%-50s %-30s %10s %10s\n" $current_dir $current_branch $current_commit $current_status
        return 0
    fi
    return 1
}

root_dir="$(readlink -m $1)"
if [ ! -d "$root_dir" ]; then
    >&2 echo "Root directory does not exist: $root_dir"
    exit 1
fi
checkout_type=$2

while read inp; do
    tokens=( $inp )
    repo_dir="$root_dir/${tokens[0]}"
    branch_name=${tokens[1]}
    commit_hash=${tokens[2]}
    old_dir="$(pwd)"
    echo "============================"
    if [ ! -d "$repo_dir" ]; then
        echo "Repository does not exist: $repo_dir"
        continue
    fi
    cd $repo_dir
    print_git_status
    git fetch
    if [ "$checkout_type" == "--branch" ]
    then
        git checkout $branch_name
    elif [ "$checkout_type" == "--commit" ]
    then
        git checkout $commit_hash
    fi
    print_git_status
    cd $old_dir
done    
