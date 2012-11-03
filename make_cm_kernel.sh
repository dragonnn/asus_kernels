#!/bin/bash

if [ ! -e ./zImage ] ; then
	echo zImage not found
	exit 1
fi
if [ ! -d ./system ] ; then
	if [ ! -d ./update/system ] ; then
		echo system not found
		exit 1
	fi
fi
if [ -e ../cm_update.zip ] ; then
	rm ../cm_update.zip
fi
find -name .gitignore | xargs rm
cd ./cm_init_rd
../bin/ramdiskrepack
cd ../
mv ramdisk.cpio.gz LNX.ramdisk.cpio.gz
./bin/mkbootimg --kernel zImage --ramdisk LNX.ramdisk.cpio.gz -o tmp
rm ./LNX.ramdisk.cpio.gz
./bin/blobpack tmp.blob LNX tmp
if [ -e ./update/kernel.blob ] ; then
	rm ./update/kernel.blob
fi
cat ./bin/blob_head ./tmp.blob > ./update/kernel.blob
if [ -d "./system" ] ; then
	rm -fr ./update/system
	mkdir -p ./system/bin/
	mkdir -p ./system/xbin/
	mkdir -p ./system/etc/init.d/
	cp ./files/busybox	./system/xbin/busybox
	cp ./files/install_busybox.sh ./system/xbin/install_busybox.sh
	cp ./files/vold		./system/bin/vold
	cp ./files/ntfs-3g	./system/bin/ntfs-3g
	cp ./files/exfat	./system/bin/exfat
	cp ./files/zram.sh	./system/etc/init.d/99zram
	mv ./system			./update/
fi
rm ./tmp ./tmp.blob
cd ./update
zip -9r ../update.zip ./*
cd ../
java -jar ./bin/SignUpdate.jar ./update.zip
mv ./signed_update.zip ../cm_update.zip
rm ./update.zip
cd ../
exit 0
