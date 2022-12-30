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

# Test cases for the_root.sh API

source src/api/root.sh

echo "================================="
echo "Test case 1"
# Global variables should be empty

if [[ -z "$global_root" && -z "$runner_root" && -z "$data_root" ]]; then
    echo "Test case 1 passed"
else
    echo "Test case 1 failed"
fi

echo "================================="
echo "Test case 2"
# Set (root)/spec as global_root
# Set (root)/spec/tests as runner_root
# Set (root)/src as data_root

global_root="$(ctm_root "$(pwd)/spec")"
runner_root="$(ctm_root "$(pwd)/spec/tests")"
data_root="$(ctm_root "$(pwd)/src")"

# echo "global_root = $global_root"
# echo "runner_root = $runner_root"
# echo "data_root = $data_root"

if ! [[ "$global_root" == "spec" ]]; then
    echo "global_root is not set correctly"
    echo "Test case 2 failed"
fi
if ! [[ "$runner_root" == "tests" ]]; then
    echo "runner_root is not set correctly"
    echo "Test case 2 failed"
fi
if ! [[ "$data_root" == "../src" ]]; then
    echo "data_root is not set correctly"
    echo "Test case 2 failed"
else
    echo "Test case 2 passed"
fi

echo "================================="
echo "All test cases passed"
