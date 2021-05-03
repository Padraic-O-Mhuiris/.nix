#!/usr/bin/env bash

set -euo pipefail

WIFI_TEXT="$HOME/wifi.txt"
GOOGLE_NS="8.8.8.8"
WPA_SUPPLICANT_CONF="/etc/wpa_supplicant.conf"

WIFI_INTERFACE=$(iw dev | grep -Po '^\sInterface\s\K.*$')

is_internet_connected () {
    if [ "$(ping -q -c1 $GOOGLE_NS)" ]
    then
        return 0
    else
        return 1
    fi
}

connect_wifi () {
    is_internet_connected && return

    if [ ! -f "$WIFI_TEXT" ]; then
        echo "Type your wifi SSID, followed by [ENTER]:"
        read -s SSID
        echo "Type your wifi Password, followed by [ENTER]:"
        read -s PASSWORD

        wpa_passphrase "$SSID" "$PASSWORD" > "$WIFI_TEXT" # have it for again
    fi

    wpa_supplicant -B -i $WIFI_INTERFACE -c $WIFI_TEXT

    while ! is_internet_connected; do
        echo "...connecting to wifi"
        sleep 1
    done

    echo "Connected!"
}

setup_ssh () {
    SSH_PASS="abc123"
    echo -e "$SSH_PASS\n$SSH_PASS" | passwd
}

connect_wifi
setup_ssh
