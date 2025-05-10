#!/usr/bin/env python3
import sys
import os
from pyhocon import ConfigFactory, HOCONConverter, ConfigTree

def usage():
    print("Usage: edit_hocon.py <file> <set|get> <key> [value]")
    sys.exit(1)

if len(sys.argv) < 4:
    usage()

conf_file = sys.argv[1]
cmd = sys.argv[2]
key = sys.argv[3]

def load_config(conf_file):
    if not os.path.exists(conf_file) or os.path.getsize(conf_file) == 0:
        return ConfigTree()
    try:
        return ConfigFactory.parse_file(conf_file)
    except Exception as e:
        print(f"Error parsing {conf_file}: {e}")
        sys.exit(1)

config = load_config(conf_file)

if cmd == "set":
    if len(sys.argv) != 5:
        usage()
    value = sys.argv[4]
    # Support nested keys
    keys = key.split('.')
    d = config
    for k in keys[:-1]:
        if k not in d or not isinstance(d[k], ConfigTree):
            d[k] = ConfigTree()
        d = d[k]
    # Try to convert value to int/bool if possible
    if value.lower() == "true":
        value = True
    elif value.lower() == "false":
        value = False
    else:
        try:
            value = int(value)
        except ValueError:
            pass
    d[keys[-1]] = value
    with open(conf_file, 'w', encoding='utf-8') as f:
        f.write(HOCONConverter.convert(config, 'hocon'))
elif cmd == "get":
    value = config
    for k in key.split('.'):
        value = value.get(k)
        if value is None:
            break
    if value is not None:
        print(value)
    else:
        sys.exit(1)
else:
    usage()
