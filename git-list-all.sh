#!/bin/bash

script_dir=`dirname "$0"`
source $script_dir/blacklisted.sh

contains() {
    [[ $1 =~ (^|[[:space:]])$2($|[[:space:]]) ]] && exit 0 || exit 1
}

function print_git_status()
{
    working_dir="$(pwd)"
    if blacklisted $working_dir
    then
        return 0
    fi
    if [ -d .git ]
    then
        working_dir="$(pwd)"
        current_dir=`realpath --relative-to=$root_dir $working_dir`
        current_branch="$(git rev-parse --abbrev-ref HEAD)"
        current_commit="$(git rev-parse --verify --short HEAD)"
        current_status=""
        if [[ `git status --porcelain` ]]; then
            current_status="M"
            #tput setaf 1
        fi
        printf "%-50s %-30s %10s %10s\n" $current_dir $current_branch $current_commit $current_status
        #tput sgr0
        return 0
    fi
    return 1
}

if [ ! -d "$1" ]; then
    >&2 echo "Error: $1 not a directory"
    exit 1
fi

root_dir="$(readlink -m $1)"

export root_dir
export -f blacklisted
export -f print_git_status
find $root_dir -mindepth 1 -type d -exec bash -c 'cd "{}" && print_git_status' \; -prune
