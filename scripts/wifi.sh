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
packages+=("wpasupplicant") # client support for WPA and WPA2 (IEEE 802.11i)
packages+=("rfkill")        # tool for enabling and disabling wireless devices
packages+=("iw")            # tool for configuring Linux wireless devices
packages+=("usbutils")      # Linux USB utilities
packages+=("pciutils")      # Linux PCI Utilities
packages+=("sudo")          # Provide limited super user privileges to specific users
sudo apt-get upgrade "${packages[*]}"
# end::packages[]


require wpa_supplicant
require systemctl
require iw
require lsusb
require lspci
require sudo


echo "Configure network links to down state"
# tag::linkdown[]
sudo ip link set eth0 down
sudo ip link set wlp2s0 down
# end::linkdown[]
# ifdown eth0
# ifdown wlan0
# ifdown wlp2s0

echo "Configure systemd-networkd"
# tag::setupetcresolvconf[]
rm /etc/resolv.conf
ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
# end::setupetcresolvconf[]

# tag::routingpriority[]
cat <<- WIRED_NETWORK > /etc/systemd/network/wired.network
  [Match]
  Name=eth0

  [Network]
  DHCP=both

  [DHCP]
  RouteMetric=10
WIRED_NETWORK

cat <<- WIRELESS_NETWORK > /etc/systemd/network/wireless.network
  [Match]
  Name=wlp2s0

  [Network]
  DHCP=both

  [DHCP]
  RouteMetric=20
WIRELESS_NETWORK
# end::routingpriority[]

echo "Enable and Start Resolved + Networkd service"
# tag::enableandstartservices[]
systemctl enable systemd-resolved.service
systemctl enable systemd-networkd.service
systemctl start systemd-resolved.service
systemctl start systemd-networkd.service
# end::enableandstartservices[]


# tag::configurewpasupplicant[]
cat <<- WPA_SUPPLICANT > /etc/wpa_supplicant/wpa_supplicant-wlp2s0.conf
  # allow frontend (e.g., wpa_cli) to be used by all users in 'wheel' group
  ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
  # ctrl_interface=/var/run/wpa_supplicant
  # DIR=/var/run/wpa_supplicant GROUP=netdev
  # ctrl_interface_group=netdev
  update_config=1

  # ISO/IEC alpha2 country code in which the device is operating
  country=AU

WPA_SUPPLICANT
# end::configurewpasupplicant[]

cat <<- WPA_PASSWORD
  Now add a WIFI network to enable wpa_supplicant to connect.

  usage: wpa_passphrase <ssid> [passphrase] >> /etc/wpa_supplicant/wpa_supplicant-wlp2s0.conf
WPA_PASSWORD

# tag::enablewpasrv[]
systemctl stop wpa_supplicant
systemctl disable wpa_supplicant

systemctl reenable wpa_supplicant@wlp2s0.service
systemctl restart wpa_supplicant@wlp2s0.service
# end::enablewpasrv[]

exit 0
