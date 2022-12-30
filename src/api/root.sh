#!/bin/bash

#//]: # ( ------------------------------------------------------------------ {c)
#//]: # ( COPYRIGHT 2022 Dwij Bavisi <dwijbavisi@gmail.com>                  {c)
#//]: # ( Licensed under:                                                    {c)
#//]: # (     Taciturn Coder's `License to Hack` License                     {c)
#//]: # (     TCsL2H 0.0.1                                                   {c)
#//]: # ( A copy of the License may be obtained from:                        {c)
#//]: # (     https://TaciturnCoder.github.io/TCsL2H/legalcode/0.0.1         {c)
#//]: # ( See the License for the permissions and limitations.               {c)
#//]: # ( ------------------------------------------------------------------ {c)

# Shell script to handle working directories

# Global variables
global_root="$(pwd)"
runner_root=""
data_root=""

# Function to get relative path from global_pwd
# Arguments:
#   1. Path to be converted
function ctm_api_root_get_() {
    local path="$1"
    local relative_path

    if [[ -f "$path" ]]; then
        path="$(dirname "$path")"
    fi
    # if path is "", replace by "."
    if [[ -z "$path" ]]; then
        path="."
    fi
    relative_path="$(realpath --relative-to="$global_root" "$path")"

    # Echo "." if relative path is empty
    if [[ -z "$relative_path" ]]; then
        relative_path="."
    fi
    echo "$relative_path"
}

# Wrappers for end user
function ctm_root() {
    ctm_api_root_get_ "$@"
}
