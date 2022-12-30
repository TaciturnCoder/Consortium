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

function ctm_api_init_() {
    # Global variables
    export ctm_api_root="$runner_root"
    export ctm_api="$ctm_api_root/src/api/api.sh"
}

function ctm_api_init() {
    # Import api files
    source "$ctm_api_root/src/api/argparse.sh"
    source "$ctm_api_root/src/api/root.sh"

    # Dependencies
    python="python"
    if ! [ -x "$(command -v $python)" ]; then
        python="python3"
        if ! [ -x "$(command -v $python)" ]; then
            echo "[Consortium] \"python\" missing! Finding Nemo..."
            echo ""
            exit 1
        fi
    fi
}

function ctm_api_extract() {
    $python "$ctm_api_root/src/configuration/read_json.py" "$@"
}

function ctm_envglobal() {
    ctm_api_extract \
        "$global_root/.consortium.json" \
        "$global_root/.consortium.json.pickle" \
        "$@"
}

function ctm_envrunner() {
    ctm_api_extract \
        "$runner_root/.consortium.json" \
        "$runner_root/.consortium.json.pickle" \
        "$@"
}

function ctm_envdata() {
    ctm_api_extract \
        "$data_root/.consortium.json" \
        "$data_root/.consortium.json.pickle" \
        "$@"
}
