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
Test cases for read_json.
"""

import sys
import os

sys.path.append("src/configuration")

print("=============================================")
print("Testing read_json")
try:
    import read_json
except ModuleNotFoundError:
    print("Unable to import module")
    exit(1)
print("Module imported successfully")

print("=============================================")
print("Testing help")
try:
    help(read_json)
except Exception:
    print("Unable to print help")
    exit(1)
print("Help printed successfully")

print("=============================================")
print("Testing check_file")
try:
    VALID_CHECK_FILE = "spec/tests/unit/configuration/sample.json"
    INVALID_CHECK_FILE = "spec/tests/unit/configuration/invalid.json"

    result_valid = read_json.check_file(VALID_CHECK_FILE, os.R_OK)
    result_invalid = read_json.check_file(INVALID_CHECK_FILE, os.R_OK)

    assert result_valid is True, "Valid file check failed"
    assert result_invalid is False, "Invalid file check failed"
except AssertionError as e:
    print("Unable to check file")
    print(e)
    exit(1)
print("File checked successfully")

print("=============================================")
print("Testing read_config_json")
try:
    VALID_READ_CONFIG_PATH = "spec/tests/unit/configuration/sample.json"
    VALID_READ_CACHE_PATH = "spec/tests/unit/configuration/sample.json.pickle"

    result_live = read_json.read_config_json(
        VALID_READ_CONFIG_PATH, True, False, VALID_READ_CACHE_PATH
    )
    result_cache = read_json.read_config_json(
        VALID_READ_CONFIG_PATH, False, False, VALID_READ_CACHE_PATH
    )

    assert result_live == result_cache, "Live and cache results differ"

    result_live = read_json.read_config_json(
        VALID_READ_CONFIG_PATH, True, True, VALID_READ_CACHE_PATH
    )
    result_cache = read_json.read_config_json(
        VALID_READ_CONFIG_PATH, False, True, VALID_READ_CACHE_PATH
    )

    assert result_live == result_cache, "Live and cache results differ"
    assert read_json.check_file(
        VALID_READ_CACHE_PATH
    ), "Cache file not created"

except AssertionError as e:
    print("Unable to read config")
    print(e)
    exit(1)
print("Config read successfully")

print("=============================================")
print("Testing read_json with invalid file")
try:
    INVALID_READ_CONFIG_PATH = "spec/tests/unit/configuration/invalid.json"
    INVALID_READ_CACHE_PATH = "spec/tests/unit/configuration/invalid.json.pickle"

    result_live = read_json.read_config_json(
        INVALID_READ_CONFIG_PATH, True, False, INVALID_READ_CACHE_PATH
    )
    result_cache = read_json.read_config_json(
        INVALID_READ_CONFIG_PATH, False, False, INVALID_READ_CACHE_PATH
    )

    assert result_live == result_cache, "Live and cache results differ"
except AssertionError as e:
    print("Unable to read config")
    print(e)
    exit(1)
print("read_json tested successfully")

print("=============================================")
print("Testing get_nested_property")
try:
    keys = [
        "$schema",
        "title",
        "type",
        "properties",
        "properties.name",
        "properties.name.type",
        "required",
        "required.0",
    ]
    values = [
        "http://json-schema.org/draft-07/schema#",
        "User",
        "object",
        "{'id': {'type': 'integer'}, 'name': {'type': 'string'}, 'email': {'type': 'string'}, 'password': {'type': 'string'}, 'created_at': {'type': 'string'}, 'updated_at': {'type': 'string'}}",
        "{'type': 'string'}",
        "string",
        "['id', 'name', 'email', 'password']",
        "id"
    ]

    data = read_json.read_config_json(
        VALID_READ_CONFIG_PATH, True, False, VALID_READ_CACHE_PATH
    )

    for i, key in enumerate(keys):
        result = read_json.get_nested_property(data, key)
        assert str(
            result) == values[i], "Invalid value returned for key: " + key

except AssertionError as e:
    print("Unable to get nested property")
    print(e)
    exit(1)
print("Nested property returned successfully")

print("=============================================")
print("Testing clean_cache")
try:
    read_json.clean_cache(VALID_READ_CACHE_PATH)
    assert not read_json.check_file(
        VALID_READ_CACHE_PATH
    ), "Cache file not deleted"
except AssertionError as e:
    print("Unable to clean cache")
    print(e)
    exit(1)
print("Cache cleaned successfully")

print("=============================================")
print("Passed all tests")
