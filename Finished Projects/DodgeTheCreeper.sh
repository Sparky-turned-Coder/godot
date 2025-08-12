#!/bin/sh
echo -ne '\033c\033]0;DodgeTheCreeper\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/DodgeTheCreeper.x86_64" "$@"
