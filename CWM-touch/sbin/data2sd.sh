#!/sbin/sh

DEVPATH=/dev/block/
DATA2SD=mmcblk1
DATA=mmcblk0p8
BUSYBOX=/sbin/busybox
MOUNTOPT=noauto_da_alloc,noatime,nosuid,nodev,nomblk_io_submit,errors=panic
FSTYPE=ext4
DATA_MOUNTPOINT=/internal_sd
DATAMEDIA_MOUNTPOINT=/data/media/internal_sd

# check for external sd card
if [ ! -e $DEVPATH$DATA2SD ] ; then
	exit 1
fi

# check for busybox
if [ ! -e $BUSYBOX ] ; then
	exit 1
fi

# check superblock for "data2sd" remount data if needed
for PARTITION in $DEVPATH$DATA2SD* ; do
	DATA2SD=${PARTITION#$DEVPATH}
	if $BUSYBOX dd if=$DEVPATH$DATA2SD skip=1144 bs=1 count=16 | $BUSYBOX grep data2sd ; then
		$BUSYBOX mkdir $DATA_MOUNTPOINT
		$BUSYBOX mount -o $MOUNTOPT -t $FSTYPE $DEVPATH$DATA $DATA_MOUNTPOINT
		$BUSYBOX umount -l /data
		$BUSYBOX mount -o $MOUNTOPT -t $FSTYPE $DEVPATH$DATA2SD /data
		SED_ARGS=s/$DATA/$DATA2SD/
		$BUSYBOX sed $SED_ARGS -i /etc/recovery.fstab
		if [ ! -d $DATAMEDIA_MOUNTPOINT ] ; then
			$BUSYBOX mkdir -p $DATAMEDIA_MOUNTPOINT
		fi
		if [ ! -d $DATA_MOUNTPOINT/media ] ; then
			$BUSYBOX mkdir -p $DATA_MOUNTPOINT/media
		fi
		$BUSYBOX mount -o bind $DATA_MOUNTPOINT/media $DATAMEDIA_MOUNTPOINT
	fi
	if $BUSYBOX dd if=$DEVPATH$DATA2SD skip=82 bs=1 count=8 | $BUSYBOX grep FAT32 ; then
		$BUSYBOX echo /external_sd vfat $DEVPATH$DATA2SD >> /etc/recovery.fstab
	fi
done

exit 0
