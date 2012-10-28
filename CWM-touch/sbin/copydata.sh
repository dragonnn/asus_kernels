#!/sbin/sh

BUSYBOX=/sbin/busybox
SOURCE=/internal_sd/
TARGET=/data/

if [ ! -d $SOURCE ] ; then
	exit 1
fi

for FILE in $SOURCE* ; do
	FILE=${FILE#$SOURCE}
	if [ "$FILE" == "media" ] ; then
		continue
	fi
	$BUSYBOX echo copying $SOURCE$FILE to $TARGET$FILE
	$BUSYBOX cp -frp $SOURCE$FILE $TARGET$FILE
done

$BUSYBOX echo syncing file system
$BUSYBOX sync
$BUSYBOX echo done
exit 0
