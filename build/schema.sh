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

mkdir -p "docs/schema"

schema_config="src/schema/.consortium.json"
_r=$(ctm_extract --raw "version.revision" --config "$schema_config")
_p=$(ctm_extract --raw "version.patch" --config "$schema_config")
_d=$(ctm_extract --raw "version.draft" --config "$schema_config")

cp "src/schema/schema.json" "docs/schema/$_r.$_p.$_d.json"
