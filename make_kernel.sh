#!/bin/bash

if [ ! -e ./zImage ] ; then
	echo zImage not found
	exit 1
fi
if [ ! -d ./system ] ; then
		echo system not found
		exit 1
fi
if [ -e ../update.zip ] ; then
	rm ../update.zip
fi
find -name .gitignore | xargs rm
cd ./init_rd
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
	mkdir -p ./update/system
	cp -frp ./system/*	./update/system/
	mkdir -p ./update/system/bin/
	mkdir -p ./update/system/xbin/
	mkdir -p ./update/system/etc/init.d/
	cp ./files/busybox	./update/system/xbin/busybox
	cp ./files/install_busybox.sh ./update/system/xbin/install_busybox.sh
	cp ./files/vold		./update/system/bin/vold
	cp ./files/ntfs-3g	./update/system/bin/ntfs-3g
	cp ./files/exfat	./update/system/bin/exfat
	cp ./files/zram.sh	./update/system/etc/init.d/99zram
fi
rm ./tmp ./tmp.blob
cd ./update
zip -9r ../update.zip ./*
cd ../
java -jar ./bin/SignUpdate.jar ./update.zip
mv ./signed_update.zip ../update.zip
rm ./update.zip
cd ../
exit 0
