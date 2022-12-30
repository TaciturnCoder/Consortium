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

echo "===> Running unit tests for configuration"
echo "===> Running unit tests for configuration: read_json.py"
python spec/tests/unit/configuration/driver_read_json.py

echo "===> Running unit tests for api"
echo "===> Running unit tests for api: argparse.sh"
bash spec/tests/unit/api/driver_argparse.sh

echo "===> Running unit tests for api: root.sh"
bash spec/tests/unit/api/driver_root.sh
