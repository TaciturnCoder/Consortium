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

declare -A ctm_xargs=()
declare -A ctm_xopts=()
declare -A ctm_xflgs=(
    [help]="Print this help message."
)

declare -A ctm_argv=()
declare -A ctm_optv=()
declare -A ctm_flgv=()
ctm_remv=()

function ctm_help() {
    local flags=()
    local options=()
    local arguments=()
    local usage=()
    local i

    # Collect usage information
    for i in "${!ctm_xflgs[@]}"; do
        flags+=("[--$i]")
    done
    for i in "${!ctm_xopts[@]}"; do
        options+=("[--$i <${i^^}>]")
    done
    for i in "${!ctm_xargs[@]}"; do
        arguments+=("<${i^^}>")
    done
    usage=("Usage: " "${flags[@]}" "${options[@]}" "${arguments[@]}")

    # Print usage information
    echo "${usage[@]}"
    echo ""

    # Print argument descriptions
    if [ ${#ctm_xargs[@]} -gt 0 ]; then
        echo "Arguments:"
        for i in "${!ctm_xargs[@]}"; do
            echo "    <${i^^}>: ${ctm_xargs[$i]}"
        done
    fi

    # Print option descriptions
    if [ ${#ctm_xopts[@]} -gt 0 ]; then
        echo "Options:"
        for i in "${!ctm_xopts[@]}"; do
            echo "    --$i <${i^^}>: ${ctm_xopts[$i]}"
        done
    fi

    # Print flag descriptions
    if [ ${#ctm_xflgs[@]} -gt 0 ]; then
        echo "Flags:"
        for i in "${!ctm_xflgs[@]}"; do
            echo "    --$i: ${ctm_xflgs[$i]}"
        done
    fi

    # Print footer
    echo ""
    echo "Powered by: Consortium"
    echo "https://github.com/TaciturnCoder/Consortium"
}

function ctm_parse() {
    local remaining=()
    local arg
    local options=("${!ctm_xopts[@]}")
    local flags=("${!ctm_xflgs[@]}")
    local i=0

    while (($# > 0)); do
        if [[ $1 =~ -- ]]; then
            arg="${1#*--}"
            if [[ " ${options[*]} " =~ " $arg " ]]; then
                ctm_optv[$arg]="$2"
                shift
            elif [[ " ${flags[*]} " =~ " $arg " ]]; then
                ctm_flgv[$arg]=true
            else
                remaining+=("$1")
            fi
        else
            remaining+=("$1")
        fi
        shift
    done

    for arg in "${!ctm_xargs[@]}"; do
        ctm_argv[$arg]="${remaining[i]}"
        i=$((i + 1))
    done

    ctm_remv=("${remaining[@]:$i}")
}

function ctm_extract() {
    $python "$ctm_root/src/extract.py" "$@"
}
