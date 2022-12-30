# //]: # ( ------------------------------------------------------------------ {c)
# //]: # ( COPYRIGHT 2022 Dwij Bavisi <dwijbavisi@gmail.com>                  {c)
# //]: # ( Licensed under:                                                    {c)
# //]: # (     Taciturn Coder's `License to Hack` License                     {c)
# //]: # (     TCsL2H 0.0.1                                                   {c)
# //]: # ( A copy of the License may be obtained from:                        {c)
# //]: # (     https://TaciturnCoder.github.io/TCsL2H/legalcode/0.0.1         {c)
# //]: # ( See the License for the permissions and limitations.               {c)
# //]: # ( ------------------------------------------------------------------ {c)

"""
Read config from JSON file.

usage: read_json.py [-h] [--clean] [--live] [--raw] [--key KEY] config_path cache_path

Read config from JSON file.

positional arguments:
  config_path  Path to config file.
  cache_path   Path to cache file.

options:
  -h, --help   show this help message and exit
  --clean      Clean cache.
  --live       Read from config file.
  --raw        Print raw data.
  --key KEY    Key to read from config.
"""

import os
from os.path import exists, isfile

import json
import pickle

import argparse


def check_file(path: str, permissions: int = os.R_OK) -> bool:
    """
    Check if a file exists and has the specified permissions.
    """
    return exists(path) and isfile(path) and os.access(path, permissions)


def read_config_json(config_path: str, live: bool, clean: bool, cache_path: str) -> dict:
    """
    Read cached config if it exists, else read config from file.
    """
    data = {}

    if not live and check_file(cache_path):
        with open(cache_path, 'rb') as cache_file:
            data = pickle.load(cache_file)
    else:
        if check_file(config_path):
            with open(config_path, 'r', encoding="utf-8") as config_file:
                try:
                    data = json.load(config_file)
                except json.JSONDecodeError:
                    clean = True
            if not clean:
                with open(cache_path, 'wb') as cache_file:
                    pickle.dump(data, cache_file)
    return data


def clean_cache(cache_path: str) -> None:
    """
    Clean cache file.
    """
    if check_file(cache_path, os.W_OK):
        os.remove(cache_path)


def get_nested_property(data: dict, key: str) -> str:
    """
    Read nested property from config.
    """
    default = ""

    for k in key.split("."):
        try:
            if isinstance(data, (list, str, tuple)):
                k = int(k)
            data = data[k]
        except (KeyError, IndexError, TypeError):
            return default
    return data


def print_values(items: list) -> None:
    """
    Print values of each items
    """
    for item in items:
        print_value(item)


def print_value(data) -> None:
    """
    Print data in raw format.
    """
    if isinstance(data, (int, str, float, bool)):
        print(data)
    elif isinstance(data, (list, tuple)):
        print_values(data)
    if isinstance(data, dict):
        print(json.dumps(data, separators=(',', ':')))


def main(args) -> None:
    """
    Main function.
    """
    if args.key:
        data = read_config_json(
            args.config_path,
            args.live,
            args.clean,
            args.cache_path
        )
        value = get_nested_property(data, args.key)

        if args.raw:
            print_value(value)
        else:
            print(json.dumps(value, separators=(',', ':')))

    if args.clean:
        clean_cache(args.cache_path)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        prog="read_json.py",
        description="Read config from JSON file."
    )

    parser.add_argument(
        "config_path",
        help="Path to config file."
    )
    parser.add_argument(
        "cache_path",
        help="Path to cache file."
    )
    parser.add_argument(
        "--clean",
        action="store_true",
        help="Clean cache."
    )
    parser.add_argument(
        "--live",
        action="store_true",
        help="Read from config file."
    )
    parser.add_argument(
        "--raw",
        action="store_true",
        help="Print raw data."
    )
    parser.add_argument(
        "--key",
        type=str,
        help="Key to read from config."
    )

    main(parser.parse_args())
