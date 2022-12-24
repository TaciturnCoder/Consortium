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

root=$(dirname "$0")

action=$1
config=$2

if [ -z "$action" ]; then
    echo "[Consortium] Speak action and Enter."
    echo ""
    exit 1
fi

if [ -z "$config" ]; then
    config=".consortium.json"
fi
if [ ! -f "$config" ]; then
    echo "[Consortium] Operation succesful. \"$config\" died?"
    echo ""
    exit 1
fi

function ctm_extract() {
    $python "$root/src/extract.py" "$@"
}

function from_config() {
    ctm_extract "$@" --config $config
}

function ctm_config() {
    ctm_extract "$@" --config "$root/.consortium.json"
}

case $action in
run-*)
    runner=$(echo "$action" | cut -d "-" -f 2-)
    scripts=$(from_config --raw "runners.$runner.scripts")
    parameters=$(from_config --raw "runners.$runner.parameters")

    echo "[Consortium] Run $runner run!"
    echo ""
    for script in $scripts; do
        if [ -f "$script" ]; then
            . "$script" $parameters
        else
            echo "[Consortium] $script cannot walk"
            echo ""
        fi
    done
    ;;
*)
    runner=$action
    scripts=$(ctm_config --raw "runners.$runner.scripts")
    parameters=$(ctm_config --raw "runners.$runner.parameters")

    echo "[Consortium] Run $runner run!"
    echo ""
    for script in $scripts; do
        if [ -f "$root/$script" ]; then
            . "$root/$script" $parameters
        else
            echo "[Consortium] $script cannot walk"
            echo ""
        fi
    done
    ;;
esac

$python "$root/src/extract.py" --clean --config $config
exit 0
