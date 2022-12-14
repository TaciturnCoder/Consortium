#!/bin/bash

# //]: # ( ------------------------------------------------------------------ {c)
# //]: # ( COPYRIGHT 2022 Dwij Bavisi <dwijbavisi@gmail.com>                  {c)
# //]: # ( Licensed under:                                                    {c)
# //]: # (     Taciturn Coder's `License to Hack` License                     {c)
# //]: # (     TCsL2H 0.0.1                                                   {c)
# //]: # ( A copy of the License may be obtained from:                        {c)
# //]: # (     https://TaciturnCoder.github.io/TCsL2H/legalcode/0.0.1         {c)
# //]: # ( See the License for the permissions and limitations.               {c)
# //]: # ( ------------------------------------------------------------------ {c)

output_dir="$runner_root/_docs/schema"
input_dir="$runner_root/src/schema"

mkdir -p "$output_dir"

_r=$(ctm_envdata --raw --key "version.revision")
_p=$(ctm_envdata --raw --key "version.patch")
_d=$(ctm_envdata --raw --key "version.draft")

cp "$input_dir/schema.json" "$output_dir/$_r.$_p.$_d.json"
