#!/bin/sh
echo -ne '\033c\033]0;Gem Catcher\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Gem Catcher.x86_64" "$@"
