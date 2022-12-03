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

editors=$(cat "$config" | jq -cr ".config.editor | @sh" | tr -d \'\")
for editor in $editors; do
    if [ -d "$consortium/src/editor/$editor" ]; then
        mkdir -p ".$editor"
        cp -R "$consortium/src/editor/$editor/"* ".$editor/"
    fi
done
