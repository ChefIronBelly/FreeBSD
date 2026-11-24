#! /bin/sh
# 
#sudo mount -t vfat /dev/sdf1 /media/usb
# doas mount -t ufs /dev/da0p1 /mnt/usb
#! /bin/sh
# 
#sudo mount -t vfat /dev/sdf1 /media/usb
doas mount -t msdosfs /dev/da0s1 /mnt/usb
