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

# Global variables
global_root="$(pwd)"
runner_root="$(realpath --relative-to="$global_root" "$(dirname "$0")")"
data_root="$runner_root"

# Import api files
source "$runner_root/src/api/api.sh"
ctm_api_init_
ctm_api_init
runner_root="$(ctm_root "$runner_root")"

# Parse command line arguments
ctm_argparse_parser

ctm_argparse_add \
    "help" \
    --f \
    --help "Print this help message and exit"
ctm_argparse_add \
    "action" \
    --r \
    --help "Action to be performed"
ctm_argparse_add \
    "config" \
    --o \
    --help "Path to configuration file"
ctm_argparse_parse "$@"

if [[ "${ctm_argflag[help]}" == "true" ]]; then
    ctm_argparse_help
    exit 0
fi

# Check if action is specified
if [[ -z "${ctm_argreq[action]}" ]]; then
    echo "[Consortium] Speak ACTION and enter!"
    echo ""
    ctm_argparse_help
    exit 1
fi

# Check if config file is specified
# else use default config file = ".consortium.json"
if [[ -n "${ctm_argopt[config]}" ]]; then
    config_file="${ctm_argopt[config]}"
else
    config_file=".consortium.json"
fi
data_root="$(ctm_root "$config_file")"

# Check if config file exists
if ! [ -f "$config_file" ]; then
    if ! [[ "${ctm_argreq[action]}" = "init" ]]; then
        echo "[Consortium] Operation succesful, '$config_file' died?"
        echo ""
        ctm_argparse_help
        exit 1
    fi
fi

# Function to run "runner" in a secure subshell
# Arguments:
#   1. Function which extracts data from config file
#   2. PWD for runner relative path
#   3. Name of runner to read from config file
function ctm_run() {
    local ctm_env="$1"
    local -r root="$2"
    local -r runner_name="$3"

    # Get list of runner scripts and pwd directories
    local -r script_list="$($ctm_env --raw --key "runners.$runner_name.scripts")"
    local -r runner_runner_root="$($ctm_env --raw --key "runners.$runner_name.pwd")"
    local -r runner_data_root="$($ctm_env --raw --key "runners.$runner_name.data")"

    echo "[Consortium] Run '$runner_name' run!"
    echo ""

    # Run each script in a subshell
    (
        # If runner_runner_root is specified
        if ! [ -z "$runner_runner_root" ]; then
            export runner_root="$runner_runner_root"
        else
            export runner_root="$runner_root"
        fi

        # If runner_data_root is specified
        if ! [ -z "$runner_data_root" ]; then
            export data_root="$runner_data_root"
        else
            export data_root="$data_root"
        fi

        for script in $script_list; do
            if ! [ -f "$root/$script" ]; then
                echo "[Consortium] '$root/$script' cannot walk!"
                echo ""
                exit 1
            else
                source "$root/$script"
            fi
        done
    )
}

# Case action
case "${ctm_argreq[action]}" in
init)
    # ctm_init
    ;;
run-*)
    runner_name=${ctm_argreq[action]#*run-}

    # Check if runner exists
    if ! [ -z $(ctm_envglobal --raw --key "runners.$runner_name") ]; then
        ctm_run ctm_envglobal "$global_root" "$runner_name"
    else
        echo "[Consortium] $runner_name is sleeping?"
        echo ""
    fi
    ;;
*)
    runner_name=${ctm_argreq[action]}

    # Check if runner exists
    if ! [ -z $(ctm_envrunner --raw --key "runners.$runner_name") ]; then
        ctm_run ctm_envrunner "$runner_root" "$runner_name"
    else
        ctm_argparse_help
        exit 1
    fi
    ;;
esac

ctm_envglobal --clean
ctm_envrunner --clean
ctm_envdata --clean
exit 0
