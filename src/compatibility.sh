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

revision=$(cat "$config" | jq -cr ".version.revision")
patch=$(cat "$config" | jq -cr ".version.patch")
draft=$(cat "$config" | jq -cr ".version.draft")
release=$(cat "$config" | jq -cr ".version.release")
build=$(cat "$config" | jq -cr ".version.build")
