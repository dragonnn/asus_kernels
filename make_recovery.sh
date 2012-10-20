#!/bin/bash

rm ../CWM-Touch.blob ../CWM-Touch.zip
cd ./CWM-touch
../ramdiskrepack
cd ../
mv ramdisk.cpio.gz SOS.ramdisk.cpio.gz
./mkbootimg --kernel zImage --ramdisk SOS.ramdisk.cpio.gz -o tmp
./blobpack tmp.blob SOS tmp
cat ./blob_head ./tmp.blob > ../CWM-Touch.blob
rm ./tmp ./tmp.blob ./SOS.ramdisk.cpio.gz
cd ../
zip -9 CWM-Touch_6.0.1.4.zip CWM-Touch.blob
