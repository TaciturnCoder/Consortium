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

# Shell script to parse command line arguments
# Usage:
#   ctm_argparse_parser
#   ctm_argparse_add "name" --r --help "help message"
#   ctm_argparse_add "name" --o --help "help message"
#   ctm_argparse_add "name" --f --help "help message"
#   ctm_argparse_parse "$@"

# Function to parse the command line arguments
# Arguments:
#   1. Required arguments
#   2. Optional arguments
#   3. Optional flags
#   4. Parsed required arguments
#   5. Parsed optional arguments
#   6. Parsed optional flags
#   7. Skipped arguments
#   8. Input to be parsed
function ctm_api_argparse_() {
    local -n required__="$1"
    local -n optional__="$2"
    local -n flag__="$3"
    declare -n parsed_required__="$4"
    declare -n parsed_optional__="$5"
    declare -n parsed_flag__="$6"
    declare -n skipped__="$7"
    shift 7

    local current__arg
    local name_required=("${!required__[@]}")
    local name_optional=("${!optional__[@]}")
    local name_flag=("${!flag__[@]}")
    local skip=()
    local i=0

    while (($# > 0)); do
        if [[ "$1" =~ -- ]]; then
            current_arg="${1#*--}"
            if [[ "${name_required[*]}" =~ "$current_arg" ]]; then
                parsed_required__[$current_arg]="$2"
                shift
            elif [[ "${name_optional[*]}" =~ "$current_arg" ]]; then
                parsed_optional__[$current_arg]="$2"
                shift
            elif [[ "${name_flag[*]}" =~ "$current_arg" ]]; then
                parsed_flag__[$current_arg]=true
            else
                skip+=("$1")
            fi
        else
            skip+=("$1")
        fi

        shift
    done

    for current_arg in "${name_required[@]}"; do
        if [[ -z ${parsed_required__[$current_arg]} ]]; then
            parsed_required__[$current_arg]="${skip[i]}"
            i=$((i + 1))
        fi
    done

    skipped__+=("${skip[@]:$i}")
}

# Function to redefine the global variables
# Arguments:
function ctm_api_argparse_redefine_() {
    # Global variables
    unset ctm_api_argparse_required_
    unset ctm_api_argparse_optional_
    unset ctm_api_argparse_flag_
    declare -Ag ctm_api_argparse_required_=()
    declare -Ag ctm_api_argparse_optional_=()
    declare -Ag ctm_api_argparse_flag_=()

    # Parsed global variables
    unset ctm_api_argparse_parsed_required_
    unset ctm_api_argparse_parsed_optional_
    unset ctm_api_argparse_parsed_flag_
    unset ctm_api_argparse_parsed_skipped_
    declare -Ag ctm_api_argparse_parsed_required_=()
    declare -Ag ctm_api_argparse_parsed_optional_=()
    declare -Ag ctm_api_argparse_parsed_flag_=()
    declare -g ctm_api_argparse_parsed_skipped_=()
}

# Function which will be visible to the user
# Simply call the ctm_api_argparse_ function with necessary arguments
function ctm_api_argparse_caller_() {
    ctm_api_argparse_ \
        ctm_api_argparse_required_ \
        ctm_api_argparse_optional_ \
        ctm_api_argparse_flag_ \
        ctm_api_argparse_parsed_required_ \
        ctm_api_argparse_parsed_optional_ \
        ctm_api_argparse_parsed_flag_ \
        ctm_api_argparse_parsed_skipped_ \
        "$@"
}

# Function which will be visible to the user
# Used to add values to the global variables
# Arguments:
#   1. Name of argument (required)
#   2. Type of argument flag (optional) [r, o, f] (default: r)
#   3. help message (optional)
function ctm_api_argparse_add_() {
    local -A required_=(
        [name]="Name of argument"
    )
    local -A optional_=(
        [help]="Help message"
    )
    local -A flag_=(
        [r]="Required argument",
        [o]="Optional argument",
        [f]="Flag"
    )

    local -A parsed_required_=()
    local -A parsed_optional_=()
    local -A parsed_flag_=()
    local parsed_skipped_=()

    ctm_api_argparse_ \
        required_ \
        optional_ \
        flag_ \
        parsed_required_ \
        parsed_optional_ \
        parsed_flag_ \
        parsed_skipped_ \
        "$@"

    local name="${parsed_required_[name]}"
    local help="${parsed_optional_[help]}"
    if ! [[ "$name" ]]; then
        echo "Error: Name of argument not provided"
        return 1
    fi

    if [[ "${parsed_flag_[o]}" == "true" ]]; then
        ctm_api_argparse_optional_[$name]="$help"
    elif [[ "${parsed_flag_[f]}" == "true" ]]; then
        ctm_api_argparse_flag_[$name]="$help"
    else
        ctm_api_argparse_required_[$name]="$help"
    fi
}

# Helper function to print help message based on the global variables
function ctm_api_argparse_help_() {
    local required__=()
    local optional__=()
    local flag__=()
    local usage="Usage: "
    local i=0

    # Print usage message
    for name in "${!ctm_api_argparse_required_[@]}"; do
        required__+=("$name")
        usage+=" <${name^^}>"
    done
    for name in "${!ctm_api_argparse_optional_[@]}"; do
        optional__+=("$name")
        usage+=" [--$name <${name^^}>]"
    done
    for name in "${!ctm_api_argparse_flag_[@]}"; do
        flag__+=("$name")
        usage+=" [--$name]"
    done
    echo "$usage"
    echo ""

    # Print required argument message
    if [[ "${#required__[@]}" -gt 0 ]]; then
        echo "Required arguments:"
        for name in "${required__[@]}"; do
            echo "  ${name^^}: ${ctm_api_argparse_required_[$name]}"
        done
        echo ""
    fi

    # Print optional argument message
    if [[ "${#optional__[@]}" -gt 0 ]]; then
        echo "Optional arguments:"
        for name in "${optional__[@]}"; do
            echo "  --$name ${name^^}: ${ctm_api_argparse_optional_[$name]}"
        done
        echo ""
    fi

    # Print flag argument message
    if [[ "${#flag__[@]}" -gt 0 ]]; then
        echo "Flags:"
        for name in "${flag__[@]}"; do
            echo "  --$name: ${ctm_api_argparse_flag_[$name]}"
        done
        echo ""
    fi

    # Print footer
    echo "Powered by: Consortium"
    echo "GitHub: https://github.com/TaciturnCoder/Consortium"
}

# Wrappers for end user
function ctm_argparse_parser() {
    ctm_api_argparse_redefine_

    declare -ng ctm_argreq=ctm_api_argparse_parsed_required_
    declare -ng ctm_argopt=ctm_api_argparse_parsed_optional_
    declare -ng ctm_argflag=ctm_api_argparse_parsed_flag_
    declare -ng ctm_argskip=ctm_api_argparse_parsed_skipped_
}
function ctm_argparse_add() {
    ctm_api_argparse_add_ "$@"
}
function ctm_argparse_parse() {
    ctm_api_argparse_caller_ "$@"
}
function ctm_argparse_help() {
    ctm_api_argparse_help_
}
