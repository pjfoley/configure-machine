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

packages+=("fonts-dejavu") # metapackage to pull in fonts-dejavu-core and fonts-dejavu-extra
packages+=("fonts-freefont-ttf") # Freefont Serif, Sans and Mono Truetype fonts
packages+=("fonts-liberation") # Fonts with the same metrics as Times, Arial and Courier
packages+=("ttf-mscorefonts-installer") # Installer for Microsoft TrueType core fonts
packages+=("fonts-ubuntu") # sans-serif font set from Ubuntu
packages+=("fonts-elusive-icons") # iconic font and CSS framework
packages+=("fonts-font-awesome") # iconic font designed for use with Twitter Bootstrap
packages+=("fonts-noto") # metapackage to pull in all Noto fonts
packages+=("fonts-inconsolata") # monospace font for pretty code listings and for the terminal
packages+=("fonts-roboto") # metapackage to pull in Roboto fonts
packages+=("xfonts-terminus") # Fixed-width fonts for fast reading 

sudo apt-get upgrade ${packages[*]}
# end::packages[]

require systemctl
require sudo




exit 0
