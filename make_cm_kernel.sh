#!/bin/bash

if [ ! -e ./zImage ] ; then
	echo zImage not found
	exit 1
fi
if [ ! -d ./system ] ; then
	echo system not found
	exit 1
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
	rm -fr ./cm_update/system
	mkdir -p ./cm_update/system
	cp -frp ./system/*	./cm_update/system/
	mkdir -p ./cm_update/system/bin/
	cp ./files/vold		./cm_update/system/bin/vold
	cp ./files/ntfs-3g	./cm_update/system/bin/ntfs-3g
	cp ./files/exfat	./cm_update/system/bin/exfat
fi
rm ./tmp ./tmp.blob
cd ./cm_update
zip -9r ../cm_update.zip ./*
cd ../
java -jar ./bin/SignUpdate.jar ./cm_update.zip
mv ./signed_cm_update.zip ../cm_update.zip
rm ./cm_update.zip
cd ../
exit 0
