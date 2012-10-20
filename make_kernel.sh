#!/bin/bash

rm ../update.zip
cd ./init_rd
../ramdiskrepack
cd ../
mv ramdisk.cpio.gz LNX.ramdisk.cpio.gz
./mkbootimg --kernel zImage --ramdisk LNX.ramdisk.cpio.gz -o tmp
rm ./LNX.ramdisk.cpio.gz
./blobpack tmp.blob LNX tmp
rm ./update/kernel.blob
cat ./blob_head ./tmp.blob > ./update/kernel.blob
if [ -d "./system" ]; then
	rm -fr ./update/system
	mkdir -p ./system/bin/
	mkdir -p ./system/etc/init.d/
	cp ./vold ./system/bin/vold
	cp ./ntfs-3g ./system/bin/ntfs-3g
	cp ./exfat ./system/bin/exfat
	cp ./zram.sh ./system/etc/init.d/99zram
	mv ./system ./update/
fi
rm ./tmp ./tmp.blob
cd ./update
zip -9r ../update.zip ./*
cd ../
java -jar SignUpdate.jar ./update.zip
mv ./signed_update.zip ../update.zip
rm ./update.zip
cd ../
exit
