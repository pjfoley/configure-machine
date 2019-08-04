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

# tag::requiredcmds[]
require sudo
# end::requiredcmds[]

# tag::packages[]
unset packages
declare -a packages

packages+=("alsa-utils") # Utilities for configuring and using ALSA
packages+=("alsa-oss") # ALSA wrapper for OSS applications
packages+=("alsamixergui") # graphical soundcard mixer for ALSA soundcard driver
packages+=("pavucontrol") # PulseAudio Volume Control
packages+=("pulseaudio") # PulseAudio sound server

packages+=("mpv") # video player based on MPlayer/mplayer2
packages+=("youtube-dl") # downloader of videos from YouTube and other sites
packages+=("ffmpeg") # Tools for transcoding, streaming and playing of multimedia files

sudo apt-get upgrade ${packages[*]}
# end::packages[]

exit 0
