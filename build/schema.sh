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

mkdir -p "$local_root/docs/schema"

config_file="$local_root/src/schema/.consortium.json"
_r=$(ctm_extract --raw "version.revision" --config "$config_file")
_p=$(ctm_extract --raw "version.patch" --config "$config_file")
_d=$(ctm_extract --raw "version.draft" --config "$config_file")

cp "$local_root/src/schema/schema.json" "$local_root/docs/schema/$_r.$_p.$_d.json"
