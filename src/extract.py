import argparse
import json
import os
from os.path import exists, isfile
import pickle


def check_file(path, permission=os.R_OK):
    return exists(path) and isfile(path) and os.access(path, permission)


def clean_cache(cache_path):
    if check_file(cache_path, os.W_OK):
        os.remove(cache_path)


def load_data(config_path):
    cache_path = config_path + ".pickle"
    data = {}

    if check_file(cache_path):
        with open(cache_path, "rb") as f:
            data = pickle.load(f)
    else:
        if check_file(config_path):
            with open(config_path) as f:
                data = json.load(f)
            if not args.clean:
                with open(cache_path, "wb") as f:
                    pickle.dump(data, f)
    return data


def deep_get(data, keys):
    for key in keys:
        try:
            if isinstance(data, list):
                key = int(key)
            data = data[key]
        except (KeyError, IndexError):
            return ""
    return data


def print_list(items):
    for item in items:
        print_value(item)


def print_value(value):
    if isinstance(value, (str, int, float, bool)):
        print(value)
    elif isinstance(value, list):
        print_list(value)
    else:
        print(json.dumps(value, separators=(",", ":")))


def main():
    config_path = args.config
    cache_path = config_path + ".pickle"

    if args.keys:
        data = load_data(config_path)
        value = deep_get(data, args.keys.split("."))

        if args.raw:
            print_value(value)
        else:
            print(json.dumps(value, separators=(",", ":")))

    if args.clean:
        clean_cache(cache_path)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("keys", nargs="?", type=str)
    parser.add_argument("--clean", action="store_true")
    parser.add_argument("--raw", action="store_true")
    parser.add_argument("--config", type=str)
    args = parser.parse_args()

    main()
