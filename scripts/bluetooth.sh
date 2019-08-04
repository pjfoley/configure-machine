#!/usr/bin/env bash
if test "$BASH" = "" || "$BASH" -uc "a=();true \"\${a[@]}\"" 2>/dev/null; then
    # Bash 4.4, Zsh
    set -euo pipefail
else
    # Bash 4.3 and older chokes on empty arrays with set -u.
    set -eo pipefail
fi
shopt -s nullglob globstar

require(){ hash "$@" || exit 127; }


# tag::packages[]
unset packages
declare -a packages
packages+=("bluetooth") # Bluetooth support (metapackage)
packages+=("pulseaudio-module-bluetooth") # Bluetooth module for PulseAudio sound server

sudo apt-get upgrade ${packages[*]}
# end::packages[]

require systemctl
require sudo




exit 0
