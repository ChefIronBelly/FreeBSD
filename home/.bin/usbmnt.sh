#! /bin/sh
# 
#sudo mount -t vfat /dev/sdf1 /media/usb
# doas mount -t ufs /dev/da0p1 /mnt/usb
#! /bin/sh
# 
#sudo mount -t vfat /dev/sdf1 /media/usb
doas mount_msdosfs /dev/da0s1 /mnt/usb
doas mount_msdosfs /dev/da0s1 /mnt/usb
