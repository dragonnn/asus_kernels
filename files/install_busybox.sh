#!/system/bin/sh

PATH=/system/xbin/
BUSYBOX=/system/xbin/busybox

/system/bin/chmod 755 $BUSYBOX
/system/bin/chown root:shell $BUSYBOX
for FILE in $PATH* ; do
	if [ -L $FILE ] ; then
		$BUSYBOX rm $FILE
	fi
done
$BUSYBOX --install -s /system/xbin
exit 0
