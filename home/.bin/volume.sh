#!/bin/sh

# FreeBSD Audio Control Script
# Usage: ./volume.sh [+|-|0]

case "$1" in
    +)
        # Increase volume by 5%
        mixer vol=+5%
        ;;
    -)
        # Decrease volume by 5%
        mixer vol=-5%
        ;;
    0)
        # Toggle mute status
        mixer vol.mute=toggle
        ;;
    *)
        # Display current volume if no valid argument is passed
        echo "Usage: $0 {up|down|mute}"
        echo "Current volume:"
        mixer vol
        ;;
esac
