#!/bin/sh
# ~/.mkshrc
#

# Do make a history
HISTFILE=~/.mksh/history
HISTSIZE=5000

#### SAFETY ####

alias rm='rm -iv'
alias mv='mv -iv'
alias cp='cp -iv'
alias ln='ln -i'

#alias ..='cd ../'
#alias ...='cd ../../'
#alias ....='cd ../../../'
alias ls='ls --color=auto'
alias la='ls -la --color=auto'
alias ll='ls -ll --color=auto'
alias md='mkdir -p -v'
alias rd='rmdir -v'
alias h='fc -l'
alias p='pwd'
alias manb='man -H'
alias grep='grep --color=auto'
#alias curl='curl -C - -LO'
alias add='doas pkg install'
alias del='doas pkg remove'
alias upd='doas pkg update'
alias upg='doas pkg upgrade'
alias search='doas pkg search'
alias clean='doas pkg clean'
alias autorem='doas pkg autoremove'
alias freeupd='doas freebsd-update fetch'
alias freeupg='doas freebsd-update install'

# REBOOT/SHUTDOWN
alias reboot='doas /sbin/reboot'
alias poweroff='doas /sbin/poweroff'
alias shutdown='doas /sbin/halt'

# Space on drive
alias disk='du -h | sort -n -r |more'

alias preview='feh -g 450x300+500+200 -R .01 --zoom fill'
#alias rec='ffmpeg -f x11grab -s 1280x800 -an -i :0.0 -c:v libvpx -b:v 5M -crf 10 -quality realtime -y -loglevel quiet'
alias rec='ffmpeg -f x11grab -s 1920x1080 -an -i :0.0 -c:v libvpx -b:v 5M -crf 10 -quality realtime -y -loglevel quiet'
alias info='info.sh'
alias todo='nvim ~/todo'
alias zzz='doas acpiconf -s 3'
alias shootme='DISPLAY=:0 import -window root ~/Pictures/scrots/scrot-$(date +%m-%d-%Y-%H-%M-%S).png'
alias free='top -n 1 | head -n 5 | tail -n 2'
alias ping='ping -c3'
alias mc='mc -a'
alias g='git'
alias gc='git commit -m "adds and tweaks"'
alias umount='doas umount /mnt/$1'
alias view='imlib2_view'
alias grab='imlib2_grab'
alias stime='doas ntpdate -v -b in.pool.ntp.org'
alias date='date +"%a %b %d, $(date +"%I:%M")"'
#alias date='date +"%a %b %d"'
alias rnet='doas service netif restart'
alias mp3='yt-dlp -x --audio-format mp3'
alias wet='curl https://wttr.in/det'
alias ifup='doas dhclient re0'
alias phup='doas dhclient ue0'
alias route='/etc/rc.d/routing restart'
alias ver='pkg info -lx '
alias img2usb='doas dd if=$ of=/dev/da0 bs=1M conv=sync'

PS1=""
 case `id -u` in
 	0) PS1="${PS1}# ";;
 	*) PS1="${PS1}$ ";;
 esac

#paleta -r

#doas() {
#    su -c "$*"
#}
