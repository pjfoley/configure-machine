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
packages+=("p7zip-full") # 7z and 7za file archivers with high compression ratio
packages+=("p7zip-rar") # non-free rar module for p7zip
packages+=("htop") # interactive processes viewer
packages+=("git") # fast, scalable, distributed revision control system
packages+=("jq") # lightweight and flexible command-line JSON processor
packages+=("rsync") # fast, versatile, remote (and local) file-copying tool
packages+=("bash-completion") # programmable completion for the bash shell
packages+=("keychain") # key manager for OpenSSH
packages+=("wget") # retrieves files from the web
packages+=("curl") # command line tool for transferring data with URL syntax
packages+=("pciutils") # Linux PCI Utilities
packages+=("lshw") # information about hardware configuration
packages+=("numlockx") # enable NumLock in X11 sessions
packages+=("mediainfo") # command-line utility for reading information from audio/video files
packages+=("stow") # Organizer for /usr/local software packages
packages+=("vim-nox") # Vi IMproved - enhanced vi editor - with scripting languages support
packages+=("neovim") # heavily refactored vim fork
packages+=("fzf") # general-purpose command-line fuzzy finder 

sudo apt-get upgrade ${packages[*]}
# end::packages[]

require systemctl
require sudo




exit 0
