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
packages+=("i3-wm") # improved dynamic tiling window manager
packages+=("i3blocks") # improved dynamic tiling window manager
packages+=("i3lock") # improved screen locker 
packages+=("acpi") # displays information on ACPI devices
packages+=("sysstat") # system performance tools for Linux
packages+=("slick-greeter") # Slick-looking LightDM greeter
packages+=("lightdm") # simple display manager
packages+=("dconf-gsettings-backend") # simple configuration storage system - GSettings back-end
packages+=("upower") # abstraction for power management
packages+=("rxvt-unicode") # RXVT-like terminal emulator with Unicode and 256-color support
packages+=("sensible-utils") # Utilities for sensible alternative selection
packages+=("ranger") # Console File Manager with VI Key Bindings
packages+=("rofi") # window switcher, run dialog and dmenu replacement
packages+=("conky-all") # highly configurable system monitor (all features enabled)
packages+=("xclip") # command line interface to X selections
packages+=("x11-xserver-utils") # X server utilities

sudo apt-get upgrade "${packages[*]}"
# end::packages[]

require systemctl
require sudo




exit 0
