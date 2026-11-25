#!/bin/sh

setxkbmap -option terminate:ctrl_alt_bksp
setxkbmap -layout us -option ctrl:nocaps

xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'

#xrandr --output VGA1 --mode 1920x1080_60.00 

xset +dpms
xset -b
xset s 1860

#xset +fp ~/.fonts
#xset fp rehash

xrdb < ~/.Xdefaults
#xsidle.sh lock &

xsetroot -cursor_name left_ptr
hsetroot -fill ~/Pictures/1-city-view.webp -blur .5
#xsetroot -mod 16 16 -bg "$(xrdb -query | awk '/\*.background/ {print $2}')" -fg "$(xrdb -query | awk '/\*.color8/ {print $2}')"
#xsetroot -solid "$(xrdb -query | awk '/\*.color8/ {print $2}')"
#bud /home/chef/Pictures/Wallpapers/11855.jpg

weather="**"
count=0

while true; do
    # Fetch weather on startup (count == 0) and every 60 minutes
    if [ "$count" -eq 0 ]; then
        new_weather=$(curl -s --max-time 5 "wttr.in/?format=%t+%C")
        # Only update if curl succeeded and didn't return an HTML error page
        case "$new_weather" in
            ""|*html*|*Unknown*) ;;
            *) weather=" | $new_weather" ;;
        esac
    fi

    xsetroot -name " $(uname)-$(uname -r)${weather}| $(date +"%a %b %d, %I:%M")"

    count=$(( (count + 1) % 60 ))
    sleep 60
done &

dwm_start.sh
