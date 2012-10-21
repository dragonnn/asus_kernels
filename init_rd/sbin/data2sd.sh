#!/system/bin/sh

DEVPATH=/dev/block/
DATA2SD=mmcblk1p1
DATA=mmcblk0p8
BUSYBOX=/system/xbin/busybox
MOUNTOPT=noauto_da_alloc,noatime,nosuid,nodev,nomblk_io_submit,errors=panic
FSTYPE=ext4

# wait for system to mount
while [ ! -d /system/app ] ; do
done

# check for busybox
if [ ! -e $BUSYBOX ] ; then
	exit 1
fi

# check superblock for "data2sd" remount data if needed
if [ -b $DEVPATH$DATA2SD ] ; then
	if $BUSYBOX dd if=$DEVPATH$DATA2SD skip=1144 bs=1 count=16 | $BUSYBOX grep data2sd ; then
		$BUSYBOX mount -o rw,remount -t rootfs rootfs /
		$BUSYBOX mkdir /internal_sd
		$BUSYBOX mount -o ro,remount -t rootfs rootfs /
		$BUSYBOX mount -o $MOUNTOPT -t $FSTYPE $DEVPATH$DATA /internal_sd
		$BUSYBOX umount -l /data
		$BUSYBOX mount -o $MOUNTOPT -t $FSTYPE $DEVPATH$DATA2SD /data
		$BUSYBOX mkdir /data/media/internal_sd
		$BUSYBOX mount -o bind /internal_sd/media /data/media/internal_sd
	fi
fi

exit 0
