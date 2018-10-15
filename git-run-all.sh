#!/bin/bash

#set -x

script_dir=`dirname "$0"`
source $script_dir/blacklisted.sh

export root_dir="$(readlink -m $1)"

export args=${@:2}

function git_apply_fn()
{
    working_dir="$(pwd)"
    if blacklisted $working_dir
    then
        return 0
    fi
    if [ -d .git ]
    then
        echo
        echo "===== $working_dir"
        eval "git $args"
        return 0
    fi
    return 1
}

export -f blacklisted
export -f git_apply_fn
find $root_dir -mindepth 1 -type d -exec bash -c 'cd "{}" && git_apply_fn' \; -prune
