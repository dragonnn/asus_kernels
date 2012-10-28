#!/bin/bash

if [ ! -e ./zImage ] ; then
	echo zImage not found
	exit 1
fi
rm ../CWM-Touch.blob ../CWM-Touch.zip
cd ./CWM-touch
../bin/ramdiskrepack
cd ../
mv ramdisk.cpio.gz SOS.ramdisk.cpio.gz
./bin/mkbootimg --kernel zImage --ramdisk SOS.ramdisk.cpio.gz -o tmp
./bin/blobpack tmp.blob SOS tmp
cat ./bin/blob_head ./tmp.blob > ../CWM-Touch.blob
rm ./tmp ./tmp.blob ./SOS.ramdisk.cpio.gz
cd ../
zip -9 CWM-Touch_6.0.1.4.zip CWM-Touch.blob
exit 0
