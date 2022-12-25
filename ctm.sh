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

python="python"
if ! [ -x "$(command -v $python)" ]; then
    python="python3"
    if ! [ -x "$(command -v $python)" ]; then
        echo "[Consortium] \"python\" missing! Finding Nemo..."
        echo ""
        exit 1
    fi
fi

global_root=$(pwd)
ctm_root=$(dirname $(realpath "$global_root/$0"))
local_root="$ctm_root"

source "$ctm_root/src/api.sh"
ctm_xargs=(
    [action]="The action to perform."
)
ctm_xopts=(
    [config]="The configuration file to use."
)
ctm_parse "$@"

if [ "${ctm_flgv[help]}" ]; then
    ctm_help
    exit 0
fi

if [ -z "${ctm_argv[action]}" ]; then
    echo "[Consortium] Speak action and Enter."
    echo ""
    exit 1
fi

if [ -z "${ctm_optv[config]}" ]; then
    ctm_optv[config]="$global_root/.consortium.json"
fi
if ! [ -f "${ctm_optv[config]}" ]; then
    echo "[Consortium] Operation succesful. \"${ctm_optv[config]}\" died?"
    echo ""
    exit 1
fi

function ctm_global() {
    ctm_extract "$@" --config "${ctm_optv[config]}"
}
function ctm_local() {
    ctm_extract "$@" --config "$local_root/.consortium.json"
}

function ctm_run() {
    local root="$1"
    local runner="$2"

    scripts=$(ctm_$1 --raw "runners.$runner.scripts")
    parameters=$(ctm_$1 --raw "runners.$runner.parameters")
    local_=$(realpath "$global_root/$(ctm_$1 --raw "runners.$runner.root")")

    declare -n path="${root}_root"

    echo "[Consortium] Run $runner run!"
    echo ""
    $(
        export global_root="$global_root"
        export ctm_root="$ctm_root"
        export local_root="$local_"
        export -f ctm_global
        export -f ctm_local

        for script in $scripts; do
            if [ -f "$path/$script" ]; then
                source "$path/$script" $parameters
            else
                echo "[Consortium] $path/$script cannot walk"
                echo ""
            fi
        done
    )
}

case ${ctm_argv[action]} in
run-*)
    runner=${ctm_argv[action]#*run-}

    if ! [ -z $(ctm_global --raw "runners.$runner") ]; then
        ctm_run "global" "$runner"
    else
        echo "[Consortium] $runner is sleeping?"
        echo ""
    fi
    ;;
*)
    runner=${ctm_argv[action]}

    if ! [ -z $(ctm_local --raw "runners.$runner") ]; then
        ctm_run "local" "$runner"
    else
        echo "[Consortium] $runner is sleeping?"
        echo ""
    fi
    ;;
esac

ctm_global --clean
exit 0
