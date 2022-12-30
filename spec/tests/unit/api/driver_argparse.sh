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

# Test cases for the argparse.sh API

source src/api/argparse.sh

echo "================================="
echo "Test case 1"
# ctm_api_argparse_ must be able to read the arguments and options
# and store appropriate values in the appropriate arrays

ctm_api_argparse_redefine_

ctm_api_argparse_ \
    ctm_api_argparse_required_ \
    ctm_api_argparse_optional_ \
    ctm_api_argparse_flag_ \
    ctm_api_argparse_parsed_required_ \
    ctm_api_argparse_parsed_optional_ \
    ctm_api_argparse_parsed_flag_ \
    ctm_api_argparse_parsed_skipped_ \
    10 20 30

if ! [[ "${ctm_api_argparse_parsed_skipped_[@]}" = "10 20 30" ]]; then
    echo "Found ${ctm_api_argparse_parsed_skipped_[@]}, 10 20 30"
    echo "Test case 1 failed"
    exit 1
else
    echo "Test case 1 passed"
fi

echo "================================="
echo "Test case 2"
# ctm_arg_parse_ must be able to read the arguments and options
# and store appropriate values in the appropriate arrays

ctm_api_argparse_redefine_

ctm_api_argparse_required_[config]="Path to configration file"
ctm_api_argparse_optional_[cache]="Path to cache file"
ctm_api_argparse_flag_[verbose]="Enable verbose mode"

ctm_api_argparse_ \
    ctm_api_argparse_required_ \
    ctm_api_argparse_optional_ \
    ctm_api_argparse_flag_ \
    ctm_api_argparse_parsed_required_ \
    ctm_api_argparse_parsed_optional_ \
    ctm_api_argparse_parsed_flag_ \
    ctm_api_argparse_parsed_skipped_ \
    --verbose \
    --cache /var/cache \
    --config /etc/config \
    "10 20 30"

if ! [[ "${ctm_api_argparse_parsed_required_[config]}" = "/etc/config" ]]; then
    echo "Found ${ctm_api_argparse_parsed_required_[config]}, /etc/config"
    echo "Test case 2 failed"
    exit 1
fi
if ! [[ "${ctm_api_argparse_parsed_optional_[cache]}" = "/var/cache" ]]; then
    echo "Found ${ctm_api_argparse_parsed_optional_[cache]}, /var/cache"
    echo "Test case 2 failed"
    exit 1
fi
if ! [[ "${ctm_api_argparse_parsed_flag_[verbose]}" = "true" ]]; then
    echo "Found ${ctm_api_argparse_parsed_flag_[verbose]}, true"
    echo "Test case 2 failed"
    exit 1
fi
if ! [[ "${ctm_api_argparse_parsed_skipped_[@]}" = "10 20 30" ]]; then
    echo "Found ${ctm_api_argparse_parsed_skipped_[@]}, 10 20 30"
    echo "Test case 2 failed"
    exit 1
else
    echo "Test case 2 passed"
fi

echo "================================="
echo "Test case 3"
# Testing the api caller

ctm_api_argparse_redefine_

ctm_api_argparse_required_[config]="Path to configration file"
ctm_api_argparse_optional_[cache]="Path to cache file"
ctm_api_argparse_flag_[verbose]="Enable verbose mode"

ctm_api_argparse_caller_ \
    --config /etc/config \
    --cache /var/cache \
    --verbose \
    "10 20 30"

if ! [[ "${ctm_api_argparse_parsed_required_[config]}" = "/etc/config" ]]; then
    echo "Found ${ctm_api_argparse_parsed_required_[config]}, /etc/config"
    echo "Test case 3 failed"
    exit 1
fi
if ! [[ "${ctm_api_argparse_parsed_optional_[cache]}" = "/var/cache" ]]; then
    echo "Found ${ctm_api_argparse_parsed_optional_[cache]}, /var/cache"
    echo "Test case 3 failed"
    exit 1
fi
if ! [[ "${ctm_api_argparse_parsed_flag_[verbose]}" = "true" ]]; then
    echo "Found ${ctm_api_argparse_parsed_flag_[verbose]}, true"
    echo "Test case 3 failed"
    exit 1
fi
if ! [[ "${ctm_api_argparse_parsed_skipped_[@]}" = "10 20 30" ]]; then
    echo "Found ${ctm_api_argparse_parsed_skipped_[@]}, 10 20 30"
    echo "Test case 3 failed"
    exit 1
else
    echo "Test case 3 passed"
fi

echo "================================="
echo "Test case 4"
# Testing the api add function

ctm_api_argparse_redefine_

ctm_api_argparse_add_ \
    config \
    --r \
    --help "Path to configration file"
ctm_api_argparse_add_ \
    --help "Path to cache file" \
    --o \
    cache
ctm_api_argparse_add_ \
    --help "Enable verbose mode" \
    --f \
    verbose

ctm_api_argparse_caller_ \
    --config /etc/config \
    --cache /var/cache \
    --verbose \
    "10 20 30"

if ! [[ "${ctm_api_argparse_parsed_required_[config]}" = "/etc/config" ]]; then
    echo "Found ${ctm_api_argparse_parsed_required_[config]}, /etc/config"
    echo "Test case 4 failed"
    exit 1
fi
if ! [[ "${ctm_api_argparse_parsed_optional_[cache]}" = "/var/cache" ]]; then
    echo "Found ${ctm_api_argparse_parsed_optional_[cache]}, /var/cache"
    echo "Test case 4 failed"
    exit 1
fi
if ! [[ "${ctm_api_argparse_parsed_flag_[verbose]}" = "true" ]]; then
    echo "Found ${ctm_api_argparse_parsed_flag_[verbose]}, true"
    echo "Test case 4 failed"
    exit 1
fi
if ! [[ "${ctm_api_argparse_parsed_skipped_[@]}" = "10 20 30" ]]; then
    echo "Found ${ctm_api_argparse_parsed_skipped_[@]}, 10 20 30"
    echo "Test case 4 failed"
    exit 1
else
    echo "Test case 4 passed"
fi

echo "================================="
echo "Passed all test cases"
