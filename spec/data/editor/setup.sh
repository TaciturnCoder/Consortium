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

editors=$(ctm_envglobal --raw --key "editor")

for editor in $editors; do
    if [ -d "$runner_root/spec/data/editor/$editor" ]; then
        mkdir -p "$global_root/.$editor"
        cp -R "$runner_root/spec/data/editor/$editor/"* "$global_root/.$editor/"
    fi
done
